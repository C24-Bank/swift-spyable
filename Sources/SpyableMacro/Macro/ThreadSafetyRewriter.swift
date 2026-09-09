import SwiftSyntax
import SwiftSyntaxBuilder

/// Rewrites an already-generated spy class so its tracked state is safe to read and write from
/// concurrent, unstructured `Task`s, closing data races that Spyable's plain, unsynchronized
/// generated properties are otherwise exposed to.
///
/// Applied as a post-processing pass over `SpyFactory`'s output — exactly like
/// `AccessLevelModifierRewriter` — so none of the generation factories need to change; this only
/// touches the *output* of `SpyFactory.classDeclaration(for:)`.
///
/// It does two things:
/// 1. Every plain stored property (`CallsCount`, `ReceivedArguments`, `ReceivedInvocations`,
///    `ThrowableError`, `ReturnValue`, `Closure`, and the `underlying` backing of a `{ get set }`
///    protocol property) is rewritten into a private backing field plus a computed accessor of
///    the property's own original access level, guarded by one shared `NSLock`.
/// 2. Each function's own bookkeeping (the call-count increment and, when present, the received
///    arguments/invocations recording) is wrapped in a single `lock()`/`unlock()` pair, so one
///    call's bookkeeping can never interleave with another's. Snapshots of whichever of
///    `ThrowableError`/`Closure`/`ReturnValue` the function needs are taken under that same lock
///    and bound to local `let`s of the same name — the existing throw-check and dispatch code
///    that follows is left completely untouched, since it already reads those exact names, which
///    now resolve to the point-in-time snapshots instead of the (locked) properties.
///
/// The lock and every backing field are named with a `__spyable`-mangled prefix rather than a
/// plain `lock`/`_name`, so they can never collide with a protocol member that happens to share
/// that name.
struct ThreadSafetyRewriter {
  private let receivedArgumentsFactory = ReceivedArgumentsFactory()
  private let receivedInvocationsFactory = ReceivedInvocationsFactory()
  private let callsCountFactory = CallsCountFactory()
  private let throwableErrorFactory = ThrowableErrorFactory()
  private let returnValueFactory = ReturnValueFactory()
  private let closureFactory = ClosureFactory()

  private let lockName = "__spyableLock"

  private func backingName(for name: String) -> String {
    "__spyable_" + name
  }

  func rewrite(_ classDeclaration: ClassDeclSyntax) -> ClassDeclSyntax {
    let functionDeclarations = classDeclaration.memberBlock.members.compactMap {
      $0.decl.as(FunctionDeclSyntax.self)
    }
    let polymorphismDetector = PolymorphismDetector(
      functions: functionDeclarations,
      prefixFactory: VariablePrefixFactory()
    )

    // Properties always precede the function(s) that reference them in generation order, so this
    // fills in before it's needed: a snapshot `let` must be declared with its backing property's
    // exact type (including `!`), since plain type inference on `let x = anIUOValue` silently
    // drops the implicit-unwrap and produces an optional the untouched dispatch code below won't
    // typecheck against.
    var propertyTypes: [String: String] = [:]

    var newMembers: [MemberBlockItemSyntax] = []
    for member in classDeclaration.memberBlock.members {
      if let variableDeclaration = member.decl.as(VariableDeclSyntax.self),
        let locked = lockedDeclarations(for: variableDeclaration)
      {
        propertyTypes[locked.name] = locked.type
        newMembers.append(MemberBlockItemSyntax(decl: DeclSyntax(locked.backing)))
        newMembers.append(MemberBlockItemSyntax(decl: DeclSyntax(locked.accessor)))
      } else if let functionDeclaration = member.decl.as(FunctionDeclSyntax.self) {
        let variablePrefix = polymorphismDetector.getVariablePrefix(for: functionDeclaration)
        newMembers.append(
          MemberBlockItemSyntax(
            decl: DeclSyntax(
              rewriteFunction(
                functionDeclaration, variablePrefix: variablePrefix, propertyTypes: propertyTypes)
            )
          )
        )
      } else {
        newMembers.append(member)
      }
    }

    // Every generated spy starts with `init() {}` as its first member — the lock sits right
    // after it, ahead of the properties/functions it guards.
    newMembers.insert(MemberBlockItemSyntax(decl: DeclSyntax(lockDeclaration)), at: 1)

    var result = classDeclaration
    result.memberBlock.members = MemberBlockItemListSyntax(newMembers)
    return result
  }

  // MARK: - Properties

  private var lockDeclaration: VariableDeclSyntax {
    try! VariableDeclSyntax(
      """
      private let \(raw: lockName) = NSLock()
      """
    )
  }

  /// A plain stored property with exactly one binding and no accessor block is one of Spyable's
  /// tracked properties (or the `underlying` backing of a `{ get set }` protocol property) —
  /// every such property shares this exact shape regardless of which factory produced it, so no
  /// per-origin knowledge is needed to find and transform them. A property that already has an
  /// accessor block (the public `{ get { underlyingX } set { ... } }` wrapper, or a `Called`
  /// computed property) is left untouched — it already just reads another property by name.
  private func lockedDeclarations(
    for variableDeclaration: VariableDeclSyntax
  ) -> (name: String, type: String, backing: VariableDeclSyntax, accessor: VariableDeclSyntax)? {
    guard variableDeclaration.bindings.count == 1,
      let binding = variableDeclaration.bindings.first,
      binding.accessorBlock == nil,
      let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      return nil
    }

    let name = identifierPattern.identifier.text
    let backing_ = backingName(for: name)
    // `CallsCount` is the one tracked property with no explicit type annotation — it relies on
    // inference from its `= 0` initializer. Every other tracked property annotates its type.
    let type = binding.typeAnnotation?.type.trimmed.description ?? "Int"
    // The property may already have been rewritten to a specific access level (by
    // AccessLevelModifierRewriter, which runs first) — that access level must survive onto the
    // accessor we generate here, or every tracked property silently regresses to `internal`
    // regardless of what the rest of the class is. The backing field is always `private`
    // regardless: it's a new implementation detail, never meant to be exposed.
    //
    // Reduced to a plain string rather than interpolating the modifiers node directly: the node
    // carries its own leading/trailing trivia from wherever it previously sat, which can make the
    // rebuilt declaration fail to parse as a single VariableDeclSyntax.
    let modifiersText =
      variableDeclaration.modifiers.isEmpty
      ? ""
      : variableDeclaration.modifiers.map(\.name.text).joined(separator: " ") + " "

    let backing: VariableDeclSyntax
    if let initializer = binding.initializer {
      backing = try! VariableDeclSyntax(
        """
        private var \(raw: backing_): \(raw: type) = \(initializer.value.trimmed)
        """
      )
    } else {
      backing = try! VariableDeclSyntax(
        """
        private var \(raw: backing_): \(raw: type)
        """
      )
    }

    let accessor = try! VariableDeclSyntax(
      """
      \(raw: modifiersText)var \(raw: name): \(raw: type) {
          get { \(raw: lockName).lock(); defer { \(raw: lockName).unlock() }; return \(raw: backing_) }
          set { \(raw: lockName).lock(); defer { \(raw: lockName).unlock() }; \(raw: backing_) = newValue }
      }
      """
    )

    return (name, type, backing, accessor)
  }

  // MARK: - Functions

  private func rewriteFunction(
    _ functionDeclaration: FunctionDeclSyntax,
    variablePrefix: String,
    propertyTypes: [String: String]
  ) -> FunctionDeclSyntax {
    guard let body = functionDeclaration.body else { return functionDeclaration }

    let parameterList = functionDeclaration.signature.parameterClause.parameters
    let hasTrackedParameters = parameterList.supportsParameterTracking

    #if canImport(SwiftSyntax600)
      let functionThrows =
        functionDeclaration.signature.effectSpecifiers?.throwsClause?.throwsSpecifier != nil
    #else
      let functionThrows = functionDeclaration.signature.effectSpecifiers?.throwsSpecifier != nil
    #endif
    let functionReturns = functionDeclaration.signature.returnClause != nil

    let bookkeepingCount = 1 + (hasTrackedParameters ? 2 : 0)
    let statements = Array(body.statements)
    guard statements.count >= bookkeepingCount else { return functionDeclaration }

    let callsCountName = callsCountFactory.variableIdentifier(variablePrefix: variablePrefix).text
    var renames: [String: TokenSyntax] = [
      callsCountName: .identifier(backingName(for: callsCountName))
    ]
    if hasTrackedParameters {
      let argumentsName = receivedArgumentsFactory.variableIdentifier(
        variablePrefix: variablePrefix, parameterList: parameterList
      ).text
      let invocationsName = receivedInvocationsFactory.variableIdentifier(
        variablePrefix: variablePrefix
      ).text
      renames[argumentsName] = .identifier(backingName(for: argumentsName))
      renames[invocationsName] = .identifier(backingName(for: invocationsName))
    }

    let renamer = RenameIdentifierRewriter(renames: renames)
    let bookkeepingStatements = statements.prefix(bookkeepingCount).map {
      renamer.rewrite($0).cast(CodeBlockItemSyntax.self)
    }
    let remainingStatements = Array(statements.dropFirst(bookkeepingCount))

    var snapshotStatements: [CodeBlockItemSyntax] = []
    if functionThrows {
      snapshotStatements.append(
        snapshotStatement(
          for: throwableErrorFactory.variableIdentifier(variablePrefix: variablePrefix),
          propertyTypes: propertyTypes
        )
      )
    }
    snapshotStatements.append(
      snapshotStatement(
        for: closureFactory.variableIdentifier(variablePrefix: variablePrefix),
        propertyTypes: propertyTypes
      )
    )
    if functionReturns {
      snapshotStatements.append(
        snapshotStatement(
          for: returnValueFactory.variableIdentifier(variablePrefix: variablePrefix),
          propertyTypes: propertyTypes
        )
      )
    }

    let newStatements: [CodeBlockItemSyntax] =
      [codeBlockItem(ExprSyntax("""
        \(raw: lockName).lock()
        """))]
      + bookkeepingStatements
      + snapshotStatements
      + [codeBlockItem(ExprSyntax("""
        \(raw: lockName).unlock()
        """))]
      + remainingStatements

    var newFunction = functionDeclaration
    newFunction.body = CodeBlockSyntax(statements: CodeBlockItemListSyntax(newStatements))
    return newFunction
  }

  /// Explicitly typing the snapshot with the backing property's own declared type matters for
  /// `ReturnValue`, which is an implicitly-unwrapped optional (`Decimal!`, say): a bare
  /// `let x = _x` would infer `x` as the *plain* optional (`Decimal?`), silently dropping the
  /// implicit unwrap — and the untouched dispatch code below (`return returnValue`) expects the
  /// non-optional type the function actually returns, not `Decimal?`.
  private func snapshotStatement(
    for name: TokenSyntax,
    propertyTypes: [String: String]
  ) -> CodeBlockItemSyntax {
    let backing_ = TokenSyntax.identifier(backingName(for: name.text))
    let declaration: VariableDeclSyntax
    if let type = propertyTypes[name.text] {
      declaration = try! VariableDeclSyntax(
        """
        let \(name): \(raw: type) = \(backing_)
        """
      )
    } else {
      declaration = try! VariableDeclSyntax(
        """
        let \(name) = \(backing_)
        """
      )
    }
    return codeBlockItem(declaration)
  }

  private func codeBlockItem(_ expression: ExprSyntax) -> CodeBlockItemSyntax {
    CodeBlockItemSyntax(item: .expr(expression))
  }

  private func codeBlockItem(_ declaration: VariableDeclSyntax) -> CodeBlockItemSyntax {
    CodeBlockItemSyntax(item: .decl(DeclSyntax(declaration)))
  }
}

/// Renames exact-match identifier tokens — never a pattern or substring match, only a token whose
/// full text equals one of the known, precomputed names being looked up.
private final class RenameIdentifierRewriter: SyntaxRewriter {
  private let renames: [String: TokenSyntax]

  init(renames: [String: TokenSyntax]) {
    self.renames = renames
  }

  override func visit(_ token: TokenSyntax) -> TokenSyntax {
    if case .identifier(let text) = token.tokenKind, let renamed = renames[text] {
      return token.with(\.tokenKind, renamed.tokenKind)
    }
    return token
  }
}
