import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import SpyableMacro

/// Expands `@Spyable` end to end, so `LedgerRewriter` runs where it does in production: after the
/// access-level and thread-safety rewriters, before the `#if` wrap.
final class UT_LedgerRewriter: XCTestCase {
  private let sut = ["Spyable": SpyableMacro.self]

  private func assertLedgerExpansion(
    of protocolDeclaration: String,
    attribute: String = "@Spyable",
    generates spyDeclaration: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    assertMacroExpansion(
      """
      \(attribute)
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        \(spyDeclaration)
        #endif
        """,
      macros: sut,
      file: file,
      line: line
    )
  }

  func testPlainSpy() {
    assertLedgerExpansion(
      of: """
        protocol Toasting {
            func showToast(_ message: String)
        }
        """,
      generates: """
        class ToastingSpy: Toasting, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_showToastCallsCount: Int = 0
            var showToastCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "showToast")
                    return __spyable_showToastCallsCount
                }
                set {
                    __spyable_showToastCallsCount = newValue
                }
            }
            var showToastCalled: Bool {
                return showToastCallsCount > 0
            }
            private var __spyable_showToastReceivedMessage: String?
            var showToastReceivedMessage: String? {
                get {
                    __spyableLedger?.markVerified(self, "showToast")
                    return __spyable_showToastReceivedMessage
                }
                set {
                    __spyable_showToastReceivedMessage = newValue
                }
            }
            private var __spyable_showToastReceivedInvocations: [String] = []
            var showToastReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "showToast")
                    return __spyable_showToastReceivedInvocations
                }
                set {
                    __spyable_showToastReceivedInvocations = newValue
                }
            }
            var showToastClosure: ((String) -> Void)?
            func showToast(_ message: String) {
                __spyableLedger?.record(self, "showToast", "ToastingSpy.showToast(_:)")
                __spyable_showToastCallsCount += 1
                __spyable_showToastReceivedMessage = (message)
                __spyable_showToastReceivedInvocations.append((message))
                showToastClosure?(message)
            }
        }
        """
    )
  }

  func testThreadSafeSpy() {
    assertLedgerExpansion(
      of: """
        protocol Toasting {
            func showToast(_ message: String)
        }
        """,
      attribute: "@Spyable(threadSafe: true)",
      generates: """
        class ToastingSpy: Toasting, @unchecked Sendable {
            init() {
            }
            private let __spyableLock = NSLock()
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_showToastCallsCount: Int = 0
            var showToastCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "showToast");
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_showToastCallsCount
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_showToastCallsCount = newValue
                }
            }
            var showToastCalled: Bool {
                return showToastCallsCount > 0
            }
            private var __spyable_showToastReceivedMessage: String?
            var showToastReceivedMessage: String? {
                get {
                    __spyableLedger?.markVerified(self, "showToast");
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_showToastReceivedMessage
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_showToastReceivedMessage = newValue
                }
            }
            private var __spyable_showToastReceivedInvocations: [String] = []
            var showToastReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "showToast");
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_showToastReceivedInvocations
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_showToastReceivedInvocations = newValue
                }
            }
            private var __spyable_showToastClosure: ((String) -> Void)?
            var showToastClosure: ((String) -> Void)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_showToastClosure
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_showToastClosure = newValue
                }
            }
            func showToast(_ message: String) {
                __spyableLedger?.record(self, "showToast", "ToastingSpy.showToast(_:)")
                __spyableLock.lock()
                __spyable_showToastCallsCount += 1
                __spyable_showToastReceivedMessage = (message)
                __spyable_showToastReceivedInvocations.append((message))
                let showToastClosure: ((String) -> Void)? = __spyable_showToastClosure
                __spyableLock.unlock()
                showToastClosure?(message)
            }
        }
        """
    )
  }

  func testPublicAccessLevel() {
    assertLedgerExpansion(
      of: """
        public protocol Reloading {
            func reload()
        }
        """,
      generates: """
        public class ReloadingSpy: Reloading, @unchecked Sendable {
            public init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_reloadCallsCount: Int = 0
            public var reloadCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "reload")
                    return __spyable_reloadCallsCount
                }
                set {
                    __spyable_reloadCallsCount = newValue
                }
            }
            public var reloadCalled: Bool {
                return reloadCallsCount > 0
            }
            public var reloadClosure: (() -> Void)?
            public
            func reload() {
                __spyableLedger?.record(self, "reload", "ReloadingSpy.reload()")
                __spyable_reloadCallsCount += 1
                reloadClosure?()
            }
        }
        """
    )
  }

  func testPackageAccessLevel() {
    assertLedgerExpansion(
      of: """
        protocol Reloading {
            func reload()
        }
        """,
      attribute: "@Spyable(accessLevel: .package)",
      generates: """
        package class ReloadingSpy: Reloading, @unchecked Sendable {
            package init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_reloadCallsCount: Int = 0
            package var reloadCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "reload")
                    return __spyable_reloadCallsCount
                }
                set {
                    __spyable_reloadCallsCount = newValue
                }
            }
            package var reloadCalled: Bool {
                return reloadCallsCount > 0
            }
            package var reloadClosure: (() -> Void)?
            package
            func reload() {
                __spyableLedger?.record(self, "reload", "ReloadingSpy.reload()")
                __spyable_reloadCallsCount += 1
                reloadClosure?()
            }
        }
        """
    )
  }

  func testOverloadedMethodsUseDescriptivePrefixes() {
    assertLedgerExpansion(
      of: """
        protocol Displaying {
            func display(text: Int)
            func display(text: String)
        }
        """,
      generates: """
        class DisplayingSpy: Displaying, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_displayTextIntCallsCount: Int = 0
            var displayTextIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "displayTextInt")
                    return __spyable_displayTextIntCallsCount
                }
                set {
                    __spyable_displayTextIntCallsCount = newValue
                }
            }
            var displayTextIntCalled: Bool {
                return displayTextIntCallsCount > 0
            }
            private var __spyable_displayTextIntReceivedText: Int?
            var displayTextIntReceivedText: Int? {
                get {
                    __spyableLedger?.markVerified(self, "displayTextInt")
                    return __spyable_displayTextIntReceivedText
                }
                set {
                    __spyable_displayTextIntReceivedText = newValue
                }
            }
            private var __spyable_displayTextIntReceivedInvocations: [Int] = []
            var displayTextIntReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "displayTextInt")
                    return __spyable_displayTextIntReceivedInvocations
                }
                set {
                    __spyable_displayTextIntReceivedInvocations = newValue
                }
            }
            var displayTextIntClosure: ((Int) -> Void)?
            func display(text: Int) {
                __spyableLedger?.record(self, "displayTextInt", "DisplayingSpy.display(text:)")
                __spyable_displayTextIntCallsCount += 1
                __spyable_displayTextIntReceivedText = (text)
                __spyable_displayTextIntReceivedInvocations.append((text))
                displayTextIntClosure?(text)
            }
            private var __spyable_displayTextStringCallsCount: Int = 0
            var displayTextStringCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "displayTextString")
                    return __spyable_displayTextStringCallsCount
                }
                set {
                    __spyable_displayTextStringCallsCount = newValue
                }
            }
            var displayTextStringCalled: Bool {
                return displayTextStringCallsCount > 0
            }
            private var __spyable_displayTextStringReceivedText: String?
            var displayTextStringReceivedText: String? {
                get {
                    __spyableLedger?.markVerified(self, "displayTextString")
                    return __spyable_displayTextStringReceivedText
                }
                set {
                    __spyable_displayTextStringReceivedText = newValue
                }
            }
            private var __spyable_displayTextStringReceivedInvocations: [String] = []
            var displayTextStringReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "displayTextString")
                    return __spyable_displayTextStringReceivedInvocations
                }
                set {
                    __spyable_displayTextStringReceivedInvocations = newValue
                }
            }
            var displayTextStringClosure: ((String) -> Void)?
            func display(text: String) {
                __spyableLedger?.record(self, "displayTextString", "DisplayingSpy.display(text:)")
                __spyable_displayTextStringCallsCount += 1
                __spyable_displayTextStringReceivedText = (text)
                __spyable_displayTextStringReceivedInvocations.append((text))
                displayTextStringClosure?(text)
            }
        }
        """
    )
  }

  func testGenericMethod() {
    assertLedgerExpansion(
      of: """
        protocol Storing {
            func store<T: Codable>(_ value: T, forKey key: String)
        }
        """,
      generates: """
        class StoringSpy: Storing, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_storeForKeyCallsCount: Int = 0
            var storeForKeyCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "storeForKey")
                    return __spyable_storeForKeyCallsCount
                }
                set {
                    __spyable_storeForKeyCallsCount = newValue
                }
            }
            var storeForKeyCalled: Bool {
                return storeForKeyCallsCount > 0
            }
            private var __spyable_storeForKeyReceivedArguments: (value: Any, key: String)?
            var storeForKeyReceivedArguments: (value: Any, key: String)? {
                get {
                    __spyableLedger?.markVerified(self, "storeForKey")
                    return __spyable_storeForKeyReceivedArguments
                }
                set {
                    __spyable_storeForKeyReceivedArguments = newValue
                }
            }
            private var __spyable_storeForKeyReceivedInvocations: [(value: Any, key: String)] = []
            var storeForKeyReceivedInvocations: [(value: Any, key: String)] {
                get {
                    __spyableLedger?.markVerified(self, "storeForKey")
                    return __spyable_storeForKeyReceivedInvocations
                }
                set {
                    __spyable_storeForKeyReceivedInvocations = newValue
                }
            }
            var storeForKeyClosure: ((Any, String) -> Void)?
            func store<T: Codable>(_ value: T, forKey key: String) {
                __spyableLedger?.record(self, "storeForKey", "StoringSpy.store(_:forKey:)")
                __spyable_storeForKeyCallsCount += 1
                __spyable_storeForKeyReceivedArguments = (value, key)
                __spyable_storeForKeyReceivedInvocations.append((value, key))
                storeForKeyClosure?(value, key)
            }
        }
        """
    )
  }

  func testAssociatedtypeProtocol() {
    assertLedgerExpansion(
      of: """
        protocol Collecting {
            associatedtype Item
            func add(_ item: Item)
        }
        """,
      generates: """
        class CollectingSpy<Item>: Collecting, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_addCallsCount: Int = 0
            var addCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "add")
                    return __spyable_addCallsCount
                }
                set {
                    __spyable_addCallsCount = newValue
                }
            }
            var addCalled: Bool {
                return addCallsCount > 0
            }
            private var __spyable_addReceivedItem: Item?
            var addReceivedItem: Item? {
                get {
                    __spyableLedger?.markVerified(self, "add")
                    return __spyable_addReceivedItem
                }
                set {
                    __spyable_addReceivedItem = newValue
                }
            }
            private var __spyable_addReceivedInvocations: [Item] = []
            var addReceivedInvocations: [Item] {
                get {
                    __spyableLedger?.markVerified(self, "add")
                    return __spyable_addReceivedInvocations
                }
                set {
                    __spyable_addReceivedInvocations = newValue
                }
            }
            var addClosure: ((Item) -> Void)?
            func add(_ item: Item) {
                __spyableLedger?.record(self, "add", "CollectingSpy.add(_:)")
                __spyable_addCallsCount += 1
                __spyable_addReceivedItem = (item)
                __spyable_addReceivedInvocations.append((item))
                addClosure?(item)
            }
        }
        """
    )
  }

  func testAsyncThrowsCommand() {
    assertLedgerExpansion(
      of: """
        protocol Syncing {
            func sync(account: Int) async throws
        }
        """,
      generates: """
        class SyncingSpy: Syncing, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_syncAccountCallsCount: Int = 0
            var syncAccountCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "syncAccount")
                    return __spyable_syncAccountCallsCount
                }
                set {
                    __spyable_syncAccountCallsCount = newValue
                }
            }
            var syncAccountCalled: Bool {
                return syncAccountCallsCount > 0
            }
            private var __spyable_syncAccountReceivedAccount: Int?
            var syncAccountReceivedAccount: Int? {
                get {
                    __spyableLedger?.markVerified(self, "syncAccount")
                    return __spyable_syncAccountReceivedAccount
                }
                set {
                    __spyable_syncAccountReceivedAccount = newValue
                }
            }
            private var __spyable_syncAccountReceivedInvocations: [Int] = []
            var syncAccountReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "syncAccount")
                    return __spyable_syncAccountReceivedInvocations
                }
                set {
                    __spyable_syncAccountReceivedInvocations = newValue
                }
            }
            var syncAccountThrowableError: (any Error)?
            var syncAccountClosure: ((Int) async throws -> Void)?
            func sync(account: Int) async throws {
                __spyableLedger?.record(self, "syncAccount", "SyncingSpy.sync(account:)")
                __spyable_syncAccountCallsCount += 1
                __spyable_syncAccountReceivedAccount = (account)
                __spyable_syncAccountReceivedInvocations.append((account))
                if let syncAccountThrowableError {
                    throw syncAccountThrowableError
                }
                try await syncAccountClosure?(account)
            }
        }
        """
    )
  }

  /// Runs the rewriter directly: the spy Spyable generates for a `rethrows` method is not valid
  /// Swift with or without the ledger (its `Closure` type spells `rethrows`), so
  /// `assertMacroExpansion` rejects the expansion before comparing it.
  func testRethrowsCommand() throws {
    let protocolDeclaration = try ProtocolDeclSyntax(
      """
      protocol Performing {
          func perform(_ action: () throws -> Void) rethrows
      }
      """
    )

    let spy = LedgerRewriter().rewrite(try SpyFactory().classDeclaration(for: protocolDeclaration))

    assertBuildResult(
      spy,
      """
      class PerformingSpy: Performing, @unchecked Sendable {
          init() {
          }
          private let __spyableLedger: SpyableLedger? = SpyableLedger.current
          private var __spyable_performCallsCount: Int = 0
          var performCallsCount: Int {
              get {
                  __spyableLedger?.markVerified(self, "perform")
                  return __spyable_performCallsCount
              }
              set {
                  __spyable_performCallsCount = newValue
              }
          }
          var performCalled: Bool {
              return performCallsCount > 0
          }
          var performThrowableError: (any Error)?
          var performClosure: ((() throws -> Void) rethrows -> Void)?
          func perform(_ action: () throws -> Void) rethrows {
              __spyableLedger?.record(self, "perform", "PerformingSpy.perform(_:)")
              __spyable_performCallsCount += 1
              if let performThrowableError {
                  throw performThrowableError
              }
              try performClosure?(action)
          }
      }
      """
    )
  }

  func testNonEscapingClosureParameterVerifiesThroughCallsCountOnly() {
    assertLedgerExpansion(
      of: """
        protocol Tapping {
            func onTap(context: String, action: () -> Void)
        }
        """,
      generates: """
        class TappingSpy: Tapping, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_onTapContextActionCallsCount: Int = 0
            var onTapContextActionCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "onTapContextAction")
                    return __spyable_onTapContextActionCallsCount
                }
                set {
                    __spyable_onTapContextActionCallsCount = newValue
                }
            }
            var onTapContextActionCalled: Bool {
                return onTapContextActionCallsCount > 0
            }
            var onTapContextActionClosure: ((String, () -> Void) -> Void)?
            func onTap(context: String, action: () -> Void) {
                __spyableLedger?.record(self, "onTapContextAction", "TappingSpy.onTap(context:action:)")
                __spyable_onTapContextActionCallsCount += 1
                onTapContextActionClosure?(context, action)
            }
        }
        """
    )
  }

  /// Each command's bookkeeping renames only its own properties: `update`'s parameter keeps its
  /// name although it equals `load`'s `CallsCount`.
  func testParameterNamedLikeAnotherCommandsPropertyIsNotRenamed() {
    assertLedgerExpansion(
      of: """
        protocol LikeGenerated {
            func load()
            func update(_ loadCallsCount: Int)
        }
        """,
      generates: """
        class LikeGeneratedSpy: LikeGenerated, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_loadCallsCount: Int = 0
            var loadCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "load")
                    return __spyable_loadCallsCount
                }
                set {
                    __spyable_loadCallsCount = newValue
                }
            }
            var loadCalled: Bool {
                return loadCallsCount > 0
            }
            var loadClosure: (() -> Void)?
            func load() {
                __spyableLedger?.record(self, "load", "LikeGeneratedSpy.load()")
                __spyable_loadCallsCount += 1
                loadClosure?()
            }
            private var __spyable_updateCallsCount: Int = 0
            var updateCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "update")
                    return __spyable_updateCallsCount
                }
                set {
                    __spyable_updateCallsCount = newValue
                }
            }
            var updateCalled: Bool {
                return updateCallsCount > 0
            }
            private var __spyable_updateReceivedLoadCallsCount: Int?
            var updateReceivedLoadCallsCount: Int? {
                get {
                    __spyableLedger?.markVerified(self, "update")
                    return __spyable_updateReceivedLoadCallsCount
                }
                set {
                    __spyable_updateReceivedLoadCallsCount = newValue
                }
            }
            private var __spyable_updateReceivedInvocations: [Int] = []
            var updateReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "update")
                    return __spyable_updateReceivedInvocations
                }
                set {
                    __spyable_updateReceivedInvocations = newValue
                }
            }
            var updateClosure: ((Int) -> Void)?
            func update(_ loadCallsCount: Int) {
                __spyableLedger?.record(self, "update", "LikeGeneratedSpy.update(_:)")
                __spyable_updateCallsCount += 1
                __spyable_updateReceivedLoadCallsCount = (loadCallsCount)
                __spyable_updateReceivedInvocations.append((loadCallsCount))
                updateClosure?(loadCallsCount)
            }
        }
        """
    )
  }

  func testExplicitVoidAndEmptyTupleReturnTypesAreCommands() {
    assertLedgerExpansion(
      of: """
        protocol Closing {
            func close() -> Void
            func cancel() -> ()
        }
        """,
      generates: """
        class ClosingSpy: Closing, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_closeCallsCount: Int = 0
            var closeCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "close")
                    return __spyable_closeCallsCount
                }
                set {
                    __spyable_closeCallsCount = newValue
                }
            }
            var closeCalled: Bool {
                return closeCallsCount > 0
            }
            var closeReturnValue: Void!
            var closeClosure: (() -> Void)?
            func close() -> Void {
                __spyableLedger?.record(self, "close", "ClosingSpy.close()")
                __spyable_closeCallsCount += 1
                if closeClosure != nil {
                    return closeClosure!()
                } else {
                    return closeReturnValue
                }
            }
            private var __spyable_cancelCallsCount: Int = 0
            var cancelCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "cancel")
                    return __spyable_cancelCallsCount
                }
                set {
                    __spyable_cancelCallsCount = newValue
                }
            }
            var cancelCalled: Bool {
                return cancelCallsCount > 0
            }
            var cancelReturnValue: ()!
            var cancelClosure: (() -> ())?
            func cancel() -> () {
                __spyableLedger?.record(self, "cancel", "ClosingSpy.cancel()")
                __spyable_cancelCallsCount += 1
                if cancelClosure != nil {
                    return cancelClosure!()
                } else {
                    return cancelReturnValue
                }
            }
        }
        """
    )
  }

  func testQueryOnlyProtocolGetsNoLedgerCode() {
    assertLedgerExpansion(
      of: """
        protocol Naming {
            func name(id: Int) -> String
            func names() async throws -> [String]
        }
        """,
      generates: """
        class NamingSpy: Naming, @unchecked Sendable {
            init() {
            }
            var nameIdCallsCount = 0
            var nameIdCalled: Bool {
                return nameIdCallsCount > 0
            }
            var nameIdReceivedId: Int?
            var nameIdReceivedInvocations: [Int] = []
            var nameIdReturnValue: String!
            var nameIdClosure: ((Int) -> String)?
            func name(id: Int) -> String {
                nameIdCallsCount += 1
                nameIdReceivedId = (id)
                nameIdReceivedInvocations.append((id))
                if nameIdClosure != nil {
                    return nameIdClosure!(id)
                } else {
                    return nameIdReturnValue
                }
            }
            var namesCallsCount = 0
            var namesCalled: Bool {
                return namesCallsCount > 0
            }
            var namesThrowableError: (any Error)?
            var namesReturnValue: [String]!
            var namesClosure: (() async throws -> [String])?
            func names() async throws -> [String] {
                namesCallsCount += 1
                if let namesThrowableError {
                    throw namesThrowableError
                }
                if namesClosure != nil {
                    return try await namesClosure!()
                } else {
                    return namesReturnValue
                }
            }
        }
        """
    )
  }

  func testMainActorProtocol() {
    assertLedgerExpansion(
      of: """
        @MainActor
        protocol Coordinator {
            func open(id: String, animated: Bool)
        }
        """,
      generates: """
        class CoordinatorSpy: Coordinator, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_openIdAnimatedCallsCount: Int = 0
            var openIdAnimatedCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "openIdAnimated")
                    return __spyable_openIdAnimatedCallsCount
                }
                set {
                    __spyable_openIdAnimatedCallsCount = newValue
                }
            }
            var openIdAnimatedCalled: Bool {
                return openIdAnimatedCallsCount > 0
            }
            private var __spyable_openIdAnimatedReceivedArguments: (id: String, animated: Bool)?
            var openIdAnimatedReceivedArguments: (id: String, animated: Bool)? {
                get {
                    __spyableLedger?.markVerified(self, "openIdAnimated")
                    return __spyable_openIdAnimatedReceivedArguments
                }
                set {
                    __spyable_openIdAnimatedReceivedArguments = newValue
                }
            }
            private var __spyable_openIdAnimatedReceivedInvocations: [(id: String, animated: Bool)] = []
            var openIdAnimatedReceivedInvocations: [(id: String, animated: Bool)] {
                get {
                    __spyableLedger?.markVerified(self, "openIdAnimated")
                    return __spyable_openIdAnimatedReceivedInvocations
                }
                set {
                    __spyable_openIdAnimatedReceivedInvocations = newValue
                }
            }
            var openIdAnimatedClosure: ((String, Bool) -> Void)?
            func open(id: String, animated: Bool) {
                __spyableLedger?.record(self, "openIdAnimated", "CoordinatorSpy.open(id:animated:)")
                __spyable_openIdAnimatedCallsCount += 1
                __spyable_openIdAnimatedReceivedArguments = (id, animated)
                __spyable_openIdAnimatedReceivedInvocations.append((id, animated))
                openIdAnimatedClosure?(id, animated)
            }
        }
        """
    )
  }

  func testPropertiesOnlyProtocolGetsNoLedgerCode() {
    assertLedgerExpansion(
      of: """
        protocol Titled {
            var title: String { get set }
            var subtitle: String? { get }
        }
        """,
      generates: """
        class TitledSpy: Titled, @unchecked Sendable {
            init() {
            }
            var title: String {
                get {
                    underlyingTitle
                }
                set {
                    underlyingTitle = newValue
                }
            }
            var underlyingTitle: (String)!
            var subtitle: String?
        }
        """
    )
  }
}
