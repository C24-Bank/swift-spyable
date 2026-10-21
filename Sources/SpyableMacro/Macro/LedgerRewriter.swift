import SwiftSyntax
import SwiftSyntaxBuilder

/// Rewrites an already-generated spy class so that, while a `SpyableLedger` is installed, every
/// *command* call (a method returning `Void`) is recorded on it, and reading that method's recorded
/// calls back marks them verified. With no ledger installed, the spy behaves exactly as before.
///
/// Applied as the last post-processing pass: after `AccessLevelModifierRewriter`, which would
/// otherwise overwrite the `private` modifiers added here, and after `ThreadSafetyRewriter`, whose
/// locked accessors it extends instead of splitting the same properties a second time.
///
/// When the spy has at least one command method, it:
/// 1. Adds `private let __spyableLedger: SpyableLedger? = SpyableLedger.current`. The spy captures
///    the ledger once, at init, so calls made later from another thread or task still reach it.
/// 2. Makes `__spyableLedger?.record(self, "<prefix>", "<Spy>.<method>(<labels>)")` the first
///    statement of every command method. Methods returning a value get no ledger code at all.
/// 3. Makes the getters of every command method's `CallsCount`, `Received…` and
///    `ReceivedInvocations` call `__spyableLedger?.markVerified(self, "<prefix>")` — `Called` reads
///    `CallsCount`, so it is covered too. On a plain spy, those stored properties are split into a
///    private backing field plus a computed accessor, and the method's own bookkeeping is pointed
///    at the backing field so it never counts as a read. A thread-safe spy already has that shape,
///    so the call is prepended to its existing getter.
///
/// The ledger type is always named unqualified: in expression position, `Spyable` resolves to the
/// macro rather than the module, so `Spyable.SpyableLedger` would not compile.
struct LedgerRewriter {
  private let callsCountFactory = CallsCountFactory()
  private let receivedArgumentsFactory = ReceivedArgumentsFactory()
  private let receivedInvocationsFactory = ReceivedInvocationsFactory()

  private let ledgerName = "__spyableLedger"

  func rewrite(_ classDeclaration: ClassDeclSyntax) -> ClassDeclSyntax {
    let functionDeclarations = classDeclaration.memberBlock.members.compactMap {
      $0.decl.as(FunctionDeclSyntax.self)
    }
    let commands = functionDeclarations.filter(\.isCommand)
    // With nothing to record, the spy keeps its exact shape — no unused ledger member.
    guard !commands.isEmpty else { return classDeclaration }

    let polymorphismDetector = PolymorphismDetector(
      functions: functionDeclarations,
      prefixFactory: VariablePrefixFactory()
    )

    // Every property whose read verifies a command, mapped to that command's variable prefix.
    var verifyingPrefixes: [String: String] = [:]
    for command in commands {
      let variablePrefix = polymorphismDetector.getVariablePrefix(for: command)
      for name in verifyingPropertyNames(of: command, variablePrefix: variablePrefix) {
        verifyingPrefixes[name] = variablePrefix
      }
    }
    let backingRenamer = RenameIdentifierRewriter(
      renames: verifyingPrefixes.keys.reduce(into: [:]) {
        $0[$1] = .identifier(StoredPropertySplit.backingName(for: $1))
      }
    )

    var newMembers: [MemberBlockItemSyntax] = []
    for member in classDeclaration.memberBlock.members {
      if let variableDeclaration = member.decl.as(VariableDeclSyntax.self),
        let name = identifierName(of: variableDeclaration),
        let variablePrefix = verifyingPrefixes[name]
      {
        newMembers += verifyingDeclarations(
          for: variableDeclaration, variablePrefix: variablePrefix
        ).map { MemberBlockItemSyntax(decl: DeclSyntax($0)) }
      } else if let functionDeclaration = member.decl.as(FunctionDeclSyntax.self),
        functionDeclaration.isCommand
      {
        let recordingFunction = recordingCommand(
          functionDeclaration,
          variablePrefix: polymorphismDetector.getVariablePrefix(for: functionDeclaration),
          spyName: classDeclaration.name.text,
          backingRenamer: backingRenamer
        )
        newMembers.append(MemberBlockItemSyntax(decl: DeclSyntax(recordingFunction)))
      } else {
        newMembers.append(member)
      }
    }

    // `init() {}` is always the first member, followed by ThreadSafetyRewriter's lock when present.
    let followsLock =
      newMembers[1].decl.as(VariableDeclSyntax.self).flatMap(identifierName(of:))
      == ThreadSafetyRewriter.lockName
    newMembers.insert(
      MemberBlockItemSyntax(decl: DeclSyntax(ledgerDeclaration)),
      at: followsLock ? 2 : 1
    )

    var result = classDeclaration
    result.memberBlock.members = MemberBlockItemListSyntax(newMembers)
    return result
  }

  // MARK: - Properties

  private var ledgerDeclaration: VariableDeclSyntax {
    try! VariableDeclSyntax(
      """
      private let \(raw: ledgerName): SpyableLedger? = SpyableLedger.current
      """
    )
  }

  private func identifierName(of variableDeclaration: VariableDeclSyntax) -> String? {
    variableDeclaration.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
  }

  /// The tracked properties that read back a command's recorded calls: its `CallsCount` and, when
  /// its parameters are tracked, its `Received…` and `ReceivedInvocations`.
  private func verifyingPropertyNames(
    of functionDeclaration: FunctionDeclSyntax,
    variablePrefix: String
  ) -> [String] {
    var names = [callsCountFactory.variableIdentifier(variablePrefix: variablePrefix).text]
    let parameterList = functionDeclaration.signature.parameterClause.parameters
    if parameterList.supportsParameterTracking {
      names.append(
        receivedArgumentsFactory.variableIdentifier(
          variablePrefix: variablePrefix, parameterList: parameterList
        ).text
      )
      names.append(
        receivedInvocationsFactory.variableIdentifier(variablePrefix: variablePrefix).text
      )
    }
    return names
  }

  private func verifyingDeclarations(
    for variableDeclaration: VariableDeclSyntax,
    variablePrefix: String
  ) -> [VariableDeclSyntax] {
    let markVerified = ExprSyntax(
      """
      \(raw: ledgerName)?.markVerified(self, \(literal: variablePrefix))
      """
    )

    // A thread-safe spy's property is already a locked accessor over a backing field.
    guard let property = StoredPropertySplit(variableDeclaration) else {
      return [prependingToGetter(markVerified, of: variableDeclaration)]
    }

    let accessor = try! VariableDeclSyntax(
      """
      \(raw: property.modifiersText)var \(raw: property.name): \(raw: property.type) {
          get {
              \(markVerified)
              return \(raw: property.backingName)
          }
          set { \(raw: property.backingName) = newValue }
      }
      """
    )
    return [property.backing, accessor]
  }

  private func prependingToGetter(
    _ expression: ExprSyntax,
    of variableDeclaration: VariableDeclSyntax
  ) -> VariableDeclSyntax {
    guard var binding = variableDeclaration.bindings.first,
      case .accessors(let accessors)? = binding.accessorBlock?.accessors
    else {
      return variableDeclaration
    }

    // Terminated with `;` like the one-line statements of the locked getter it joins.
    let statement = CodeBlockItemSyntax(item: .expr(expression), semicolon: .semicolonToken())
    binding.accessorBlock?.accessors = .accessors(
      AccessorDeclListSyntax(
        accessors.map { accessor in
          guard accessor.accessorSpecifier.tokenKind == .keyword(.get), var body = accessor.body
          else {
            return accessor
          }
          body.statements = CodeBlockItemListSyntax([statement] + Array(body.statements))
          return accessor.with(\.body, body)
        }
      )
    )

    var result = variableDeclaration
    result.bindings = PatternBindingListSyntax([binding])
    return result
  }

  // MARK: - Functions

  private func recordingCommand(
    _ functionDeclaration: FunctionDeclSyntax,
    variablePrefix: String,
    spyName: String,
    backingRenamer: RenameIdentifierRewriter
  ) -> FunctionDeclSyntax {
    guard var body = functionDeclaration.body else { return functionDeclaration }

    let argumentLabels = functionDeclaration.signature.parameterClause.parameters
      .map { $0.firstName.text + ":" }
      .joined()
    let description = "\(spyName).\(functionDeclaration.name.text)(\(argumentLabels))"
    let record = CodeBlockItemSyntax(
      item: .expr(
        ExprSyntax(
          """
          \(raw: ledgerName)?.record(self, \(literal: variablePrefix), \(literal: description))
          """
        )
      )
    )

    // The spy's own bookkeeping writes the backing fields, so it never counts as a read. On a
    // thread-safe spy it already does, and this finds nothing left to rename.
    let bookkeeping = backingRenamer.rewrite(body.statements).cast(CodeBlockItemListSyntax.self)
    body.statements = CodeBlockItemListSyntax([record] + Array(bookkeeping))

    var newFunction = functionDeclaration
    newFunction.body = body
    return newFunction
  }
}
