import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import SpyableMacro

final class UT_SpyableMacro: XCTestCase {
  private let sut = ["Spyable": SpyableMacro.self]

  func testMacro() {
    let protocolDeclaration = """
      public protocol ServiceProtocol {
          var name: String {
              get
          }
          var anyProtocol: any Codable {
              get
              set
          }
          var secondName: String? {
              get
          }
          var added: () -> Void {
              get
              set
          }
          var removed: (() -> Void)? {
              get
              set
          }

          mutating func logout()
          func initialize(name: String, secondName: String?)
          func fetchConfig() async throws -> [String: String]
          func fetchData(_ name: (String, count: Int)) async -> (() -> Void)
          func fetchUsername(context: String, completion: @escaping (String) -> Void)
          func onTapBack(context: String, action: () -> Void)
          func onTapNext(context: String, action: @Sendable () -> Void)
          func assert(_ message: @autoclosure () -> String)
          func useGenerics<T, U>(values1: [T], values2: Array<U>, values3: (T, U, Int))
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        public class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
            public init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            public var name: String {
                get {
                    underlyingName
                }
                set {
                    underlyingName = newValue
                }
            }
            public var underlyingName: (String)!
            public var anyProtocol: any Codable {
                get {
                    underlyingAnyProtocol
                }
                set {
                    underlyingAnyProtocol = newValue
                }
            }
            public var underlyingAnyProtocol: (any Codable)!
            public
            var secondName: String?
            public var added: () -> Void {
                get {
                    underlyingAdded
                }
                set {
                    underlyingAdded = newValue
                }
            }
            public var underlyingAdded: (() -> Void)!
            public
            var removed: (() -> Void)?
            private var __spyable_logoutCallsCount: Int = 0
            public var logoutCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "logout")
                    return __spyable_logoutCallsCount
                }
                set {
                    __spyable_logoutCallsCount = newValue
                }
            }
            public var logoutCalled: Bool {
                return logoutCallsCount > 0
            }
            public var logoutClosure: (() -> Void)?
            public func logout() {
                __spyableLedger?.record(self, "logout", "ServiceProtocolSpy.logout()")
                __spyable_logoutCallsCount += 1
                logoutClosure?()
            }
            private var __spyable_initializeNameSecondNameCallsCount: Int = 0
            public var initializeNameSecondNameCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "initializeNameSecondName")
                    return __spyable_initializeNameSecondNameCallsCount
                }
                set {
                    __spyable_initializeNameSecondNameCallsCount = newValue
                }
            }
            public var initializeNameSecondNameCalled: Bool {
                return initializeNameSecondNameCallsCount > 0
            }
            private var __spyable_initializeNameSecondNameReceivedArguments: (name: String, secondName: String?)?
            public var initializeNameSecondNameReceivedArguments: (name: String, secondName: String?)? {
                get {
                    __spyableLedger?.markVerified(self, "initializeNameSecondName")
                    return __spyable_initializeNameSecondNameReceivedArguments
                }
                set {
                    __spyable_initializeNameSecondNameReceivedArguments = newValue
                }
            }
            private var __spyable_initializeNameSecondNameReceivedInvocations: [(name: String, secondName: String?)] = []
            public var initializeNameSecondNameReceivedInvocations: [(name: String, secondName: String?)] {
                get {
                    __spyableLedger?.markVerified(self, "initializeNameSecondName")
                    return __spyable_initializeNameSecondNameReceivedInvocations
                }
                set {
                    __spyable_initializeNameSecondNameReceivedInvocations = newValue
                }
            }
            public var initializeNameSecondNameClosure: ((String, String?) -> Void)?
            public
            func initialize(name: String, secondName: String?) {
                __spyableLedger?.record(self, "initializeNameSecondName", "ServiceProtocolSpy.initialize(name:secondName:)")
                __spyable_initializeNameSecondNameCallsCount += 1
                __spyable_initializeNameSecondNameReceivedArguments = (name, secondName)
                __spyable_initializeNameSecondNameReceivedInvocations.append((name, secondName))
                initializeNameSecondNameClosure?(name, secondName)
            }
            public var fetchConfigCallsCount = 0
            public var fetchConfigCalled: Bool {
                return fetchConfigCallsCount > 0
            }
            public var fetchConfigThrowableError: (any Error)?
            public var fetchConfigReturnValue: [String: String]!
            public var fetchConfigClosure: (() async throws -> [String: String])?
            public
            func fetchConfig() async throws -> [String: String] {
                fetchConfigCallsCount += 1
                if let fetchConfigThrowableError {
                    throw fetchConfigThrowableError
                }
                if fetchConfigClosure != nil {
                    return try await fetchConfigClosure!()
                } else {
                    return fetchConfigReturnValue
                }
            }
            public var fetchDataCallsCount = 0
            public var fetchDataCalled: Bool {
                return fetchDataCallsCount > 0
            }
            public var fetchDataReceivedName: (String, count: Int)?
            public var fetchDataReceivedInvocations: [(String, count: Int)] = []
            public var fetchDataReturnValue: (() -> Void)!
            public var fetchDataClosure: (((String, count: Int)) async -> (() -> Void))?
            public
            func fetchData(_ name: (String, count: Int)) async -> (() -> Void) {
                fetchDataCallsCount += 1
                fetchDataReceivedName = (name)
                fetchDataReceivedInvocations.append((name))
                if fetchDataClosure != nil {
                    return await fetchDataClosure!(name)
                } else {
                    return fetchDataReturnValue
                }
            }
            private var __spyable_fetchUsernameContextCompletionCallsCount: Int = 0
            public var fetchUsernameContextCompletionCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionCallsCount
                }
                set {
                    __spyable_fetchUsernameContextCompletionCallsCount = newValue
                }
            }
            public var fetchUsernameContextCompletionCalled: Bool {
                return fetchUsernameContextCompletionCallsCount > 0
            }
            private var __spyable_fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)?
            public var fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)? {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionReceivedArguments
                }
                set {
                    __spyable_fetchUsernameContextCompletionReceivedArguments = newValue
                }
            }
            private var __spyable_fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] = []
            public var fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionReceivedInvocations
                }
                set {
                    __spyable_fetchUsernameContextCompletionReceivedInvocations = newValue
                }
            }
            public var fetchUsernameContextCompletionClosure: ((String, @escaping (String) -> Void) -> Void)?
            public
            func fetchUsername(context: String, completion: @escaping (String) -> Void) {
                __spyableLedger?.record(self, "fetchUsernameContextCompletion", "ServiceProtocolSpy.fetchUsername(context:completion:)")
                __spyable_fetchUsernameContextCompletionCallsCount += 1
                __spyable_fetchUsernameContextCompletionReceivedArguments = (context, completion)
                __spyable_fetchUsernameContextCompletionReceivedInvocations.append((context, completion))
                fetchUsernameContextCompletionClosure?(context, completion)
            }
            private var __spyable_onTapBackContextActionCallsCount: Int = 0
            public var onTapBackContextActionCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "onTapBackContextAction")
                    return __spyable_onTapBackContextActionCallsCount
                }
                set {
                    __spyable_onTapBackContextActionCallsCount = newValue
                }
            }
            public var onTapBackContextActionCalled: Bool {
                return onTapBackContextActionCallsCount > 0
            }
            public var onTapBackContextActionClosure: ((String, () -> Void) -> Void)?
            public
            func onTapBack(context: String, action: () -> Void) {
                __spyableLedger?.record(self, "onTapBackContextAction", "ServiceProtocolSpy.onTapBack(context:action:)")
                __spyable_onTapBackContextActionCallsCount += 1
                onTapBackContextActionClosure?(context, action)
            }
            private var __spyable_onTapNextContextActionCallsCount: Int = 0
            public var onTapNextContextActionCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "onTapNextContextAction")
                    return __spyable_onTapNextContextActionCallsCount
                }
                set {
                    __spyable_onTapNextContextActionCallsCount = newValue
                }
            }
            public var onTapNextContextActionCalled: Bool {
                return onTapNextContextActionCallsCount > 0
            }
            public var onTapNextContextActionClosure: ((String, @Sendable () -> Void) -> Void)?
            public
            func onTapNext(context: String, action: @Sendable () -> Void) {
                __spyableLedger?.record(self, "onTapNextContextAction", "ServiceProtocolSpy.onTapNext(context:action:)")
                __spyable_onTapNextContextActionCallsCount += 1
                onTapNextContextActionClosure?(context, action)
            }
            private var __spyable_assertCallsCount: Int = 0
            public var assertCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "assert")
                    return __spyable_assertCallsCount
                }
                set {
                    __spyable_assertCallsCount = newValue
                }
            }
            public var assertCalled: Bool {
                return assertCallsCount > 0
            }
            public var assertClosure: ((@autoclosure () -> String) -> Void)?
            public
            func assert(_ message: @autoclosure () -> String) {
                __spyableLedger?.record(self, "assert", "ServiceProtocolSpy.assert(_:)")
                __spyable_assertCallsCount += 1
                assertClosure?(message())
            }
            private var __spyable_useGenericsValues1Values2Values3CallsCount: Int = 0
            public var useGenericsValues1Values2Values3CallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "useGenericsValues1Values2Values3")
                    return __spyable_useGenericsValues1Values2Values3CallsCount
                }
                set {
                    __spyable_useGenericsValues1Values2Values3CallsCount = newValue
                }
            }
            public var useGenericsValues1Values2Values3Called: Bool {
                return useGenericsValues1Values2Values3CallsCount > 0
            }
            private var __spyable_useGenericsValues1Values2Values3ReceivedArguments: (values1: [Any], values2: Array<Any>, values3: (Any, Any, Int))?
            public var useGenericsValues1Values2Values3ReceivedArguments: (values1: [Any], values2: Array<Any>, values3: (Any, Any, Int))? {
                get {
                    __spyableLedger?.markVerified(self, "useGenericsValues1Values2Values3")
                    return __spyable_useGenericsValues1Values2Values3ReceivedArguments
                }
                set {
                    __spyable_useGenericsValues1Values2Values3ReceivedArguments = newValue
                }
            }
            private var __spyable_useGenericsValues1Values2Values3ReceivedInvocations: [(values1: [Any], values2: Array<Any>, values3: (Any, Any, Int))] = []
            public var useGenericsValues1Values2Values3ReceivedInvocations: [(values1: [Any], values2: Array<Any>, values3: (Any, Any, Int))] {
                get {
                    __spyableLedger?.markVerified(self, "useGenericsValues1Values2Values3")
                    return __spyable_useGenericsValues1Values2Values3ReceivedInvocations
                }
                set {
                    __spyable_useGenericsValues1Values2Values3ReceivedInvocations = newValue
                }
            }
            public var useGenericsValues1Values2Values3Closure: (([Any], Array<Any>, (Any, Any, Int)) -> Void)?
            public
            func useGenerics<T, U>(values1: [T], values2: Array<U>, values3: (T, U, Int)) {
                __spyableLedger?.record(self, "useGenericsValues1Values2Values3", "ServiceProtocolSpy.useGenerics(values1:values2:values3:)")
                __spyable_useGenericsValues1Values2Values3CallsCount += 1
                __spyable_useGenericsValues1Values2Values3ReceivedArguments = (values1, values2, values3)
                __spyable_useGenericsValues1Values2Values3ReceivedInvocations.append((values1, values2, values3))
                useGenericsValues1Values2Values3Closure?(values1, values2, values3)
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  // MARK: - `behindPreprocessorFlag` argument

  func testMacroWithNoArgument() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      @Spyable()
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithNoBehindPreprocessorFlagArgument() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      @Spyable(someOtherArgument: 1)
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithBehindPreprocessorFlagArgument() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      @Spyable(behindPreprocessorFlag: "CUSTOM")
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if CUSTOM
        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithBehindPreprocessorFlagArgumentAndOtherAttributes() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      @MainActor
      @Spyable(behindPreprocessorFlag: "CUSTOM")
      @available(*, deprecated)
      \(protocolDeclaration)
      """,
      expandedSource: """

        @MainActor
        @available(*, deprecated)
        \(protocolDeclaration)

        #if CUSTOM
        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithBehindPreprocessorFlagArgumentWithInterpolation() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      #"""
      @Spyable(behindPreprocessorFlag: "CUSTOM\(123)FLAG")
      \#(protocolDeclaration)
      """#,
      expandedSource: """

        \(protocolDeclaration)

        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "The `behindPreprocessorFlag` argument requires a static string literal",
          line: 1,
          column: 1,
          notes: [
            NoteSpec(
              message:
                "Provide a literal string value without any dynamic expressions or interpolations to meet the static string literal requirement.",
              line: 1,
              column: 34
            )
          ]
        )
      ],
      macros: sut
    )
  }

  func testMacroWithBehindPreprocessorFlagArgumentFromVariable() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      let myCustomFlag = "DEBUG"

      @Spyable(behindPreprocessorFlag: myCustomFlag)
      \(protocolDeclaration)
      """,
      expandedSource: """
        let myCustomFlag = "DEBUG"
        \(protocolDeclaration)

        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "The `behindPreprocessorFlag` argument requires a static string literal",
          line: 3,
          column: 1,
          notes: [
            NoteSpec(
              message:
                "Provide a literal string value without any dynamic expressions or interpolations to meet the static string literal requirement.",
              line: 3,
              column: 34
            )
          ]
        )
      ],
      macros: sut
    )
  }

  func testSpyClassAccessLevelsMatchProtocolAccessLevels() {
    let accessLevelMappings = [
      (protocolAccessLevel: "public", spyClassAccessLevel: "public"),
      (protocolAccessLevel: "package", spyClassAccessLevel: "package"),
      (protocolAccessLevel: "internal", spyClassAccessLevel: "internal"),
      (protocolAccessLevel: "fileprivate", spyClassAccessLevel: "fileprivate"),
      (protocolAccessLevel: "private", spyClassAccessLevel: "fileprivate"),
    ]

    for mapping in accessLevelMappings {
      let protocolDefinition = """
        \(mapping.protocolAccessLevel) protocol ServiceProtocol {
            var removed: (() -> Void)? { get set }

            func fetchUsername(context: String, completion: @escaping (String) -> Void)
        }
        """

      assertMacroExpansion(
        """
        @Spyable
        \(protocolDefinition)
        """,
        expandedSource: """

          \(protocolDefinition)

          #if DEBUG
          \(mapping.spyClassAccessLevel) class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
              \(mapping.spyClassAccessLevel) init() {
              }
              private let __spyableLedger: SpyableLedger? = SpyableLedger.current
              \(mapping.spyClassAccessLevel)
              var removed: (() -> Void)?
              private var __spyable_fetchUsernameContextCompletionCallsCount: Int = 0
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionCallsCount: Int {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionCallsCount
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionCallsCount = newValue
                  }
              }
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionCalled: Bool {
                  return fetchUsernameContextCompletionCallsCount > 0
              }
              private var __spyable_fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)?
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)? {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionReceivedArguments
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionReceivedArguments = newValue
                  }
              }
              private var __spyable_fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] = []
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionReceivedInvocations
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionReceivedInvocations = newValue
                  }
              }
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionClosure: ((String, @escaping (String) -> Void) -> Void)?
              \(mapping.spyClassAccessLevel)

              func fetchUsername(context: String, completion: @escaping (String) -> Void) {
                  __spyableLedger?.record(self, "fetchUsernameContextCompletion", "ServiceProtocolSpy.fetchUsername(context:completion:)")
                  __spyable_fetchUsernameContextCompletionCallsCount += 1
                  __spyable_fetchUsernameContextCompletionReceivedArguments = (context, completion)
                  __spyable_fetchUsernameContextCompletionReceivedInvocations.append((context, completion))
                  fetchUsernameContextCompletionClosure?(context, completion)
              }
          }
          #endif
          """,
        macros: sut
      )
    }
  }

  func testMacroWithAccessLevelArgument() {
    let accessLevelMappings = [
      (protocolAccessLevel: "public", spyClassAccessLevel: "public"),
      (protocolAccessLevel: "package", spyClassAccessLevel: "package"),
      (protocolAccessLevel: "internal", spyClassAccessLevel: "internal"),
      (protocolAccessLevel: "fileprivate", spyClassAccessLevel: "fileprivate"),
      (protocolAccessLevel: "private", spyClassAccessLevel: "fileprivate"),
    ]

    for mapping in accessLevelMappings {
      let protocolDefinition = """
        protocol ServiceProtocol {
            var removed: (() -> Void)? { get set }

            func fetchUsername(context: String, completion: @escaping (String) -> Void)
        }
        """

      assertMacroExpansion(
        """
        @Spyable(accessLevel: .\(mapping.protocolAccessLevel))
        \(protocolDefinition)
        """,
        expandedSource: """

          \(protocolDefinition)

          #if DEBUG
          \(mapping.spyClassAccessLevel) class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
              \(mapping.spyClassAccessLevel) init() {
              }
              private let __spyableLedger: SpyableLedger? = SpyableLedger.current
              \(mapping.spyClassAccessLevel)
              var removed: (() -> Void)?
              private var __spyable_fetchUsernameContextCompletionCallsCount: Int = 0
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionCallsCount: Int {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionCallsCount
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionCallsCount = newValue
                  }
              }
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionCalled: Bool {
                  return fetchUsernameContextCompletionCallsCount > 0
              }
              private var __spyable_fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)?
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)? {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionReceivedArguments
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionReceivedArguments = newValue
                  }
              }
              private var __spyable_fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] = []
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] {
                  get {
                      __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                      return __spyable_fetchUsernameContextCompletionReceivedInvocations
                  }
                  set {
                      __spyable_fetchUsernameContextCompletionReceivedInvocations = newValue
                  }
              }
              \(mapping.spyClassAccessLevel) var fetchUsernameContextCompletionClosure: ((String, @escaping (String) -> Void) -> Void)?
              \(mapping.spyClassAccessLevel)

              func fetchUsername(context: String, completion: @escaping (String) -> Void) {
                  __spyableLedger?.record(self, "fetchUsernameContextCompletion", "ServiceProtocolSpy.fetchUsername(context:completion:)")
                  __spyable_fetchUsernameContextCompletionCallsCount += 1
                  __spyable_fetchUsernameContextCompletionReceivedArguments = (context, completion)
                  __spyable_fetchUsernameContextCompletionReceivedInvocations.append((context, completion))
                  fetchUsernameContextCompletionClosure?(context, completion)
              }
          }
          #endif
          """,
        macros: sut
      )
    }
  }

  func testMacroWithAccessLevelArgumentOverridingInheritedAccessLevel() {
    let protocolDeclaration = """
      public protocol ServiceProtocol {
          var removed: (() -> Void)? { get set }

          func fetchUsername(context: String, completion: @escaping (String) -> Void)
      }
      """

    assertMacroExpansion(
      """
      @Spyable(accessLevel: .fileprivate)
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        fileprivate class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
            fileprivate init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            fileprivate
            var removed: (() -> Void)?
            private var __spyable_fetchUsernameContextCompletionCallsCount: Int = 0
            fileprivate var fetchUsernameContextCompletionCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionCallsCount
                }
                set {
                    __spyable_fetchUsernameContextCompletionCallsCount = newValue
                }
            }
            fileprivate var fetchUsernameContextCompletionCalled: Bool {
                return fetchUsernameContextCompletionCallsCount > 0
            }
            private var __spyable_fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)?
            fileprivate var fetchUsernameContextCompletionReceivedArguments: (context: String, completion: (String) -> Void)? {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionReceivedArguments
                }
                set {
                    __spyable_fetchUsernameContextCompletionReceivedArguments = newValue
                }
            }
            private var __spyable_fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] = []
            fileprivate var fetchUsernameContextCompletionReceivedInvocations: [(context: String, completion: (String) -> Void)] {
                get {
                    __spyableLedger?.markVerified(self, "fetchUsernameContextCompletion")
                    return __spyable_fetchUsernameContextCompletionReceivedInvocations
                }
                set {
                    __spyable_fetchUsernameContextCompletionReceivedInvocations = newValue
                }
            }
            fileprivate var fetchUsernameContextCompletionClosure: ((String, @escaping (String) -> Void) -> Void)?
            fileprivate

            func fetchUsername(context: String, completion: @escaping (String) -> Void) {
                __spyableLedger?.record(self, "fetchUsernameContextCompletion", "ServiceProtocolSpy.fetchUsername(context:completion:)")
                __spyable_fetchUsernameContextCompletionCallsCount += 1
                __spyable_fetchUsernameContextCompletionReceivedArguments = (context, completion)
                __spyable_fetchUsernameContextCompletionReceivedInvocations.append((context, completion))
                fetchUsernameContextCompletionClosure?(context, completion)
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithAllArgumentsAndOtherAttributes() {
    let protocolDeclaration = "public protocol MyProtocol {}"

    assertMacroExpansion(
      """
      @MainActor
      @Spyable(behindPreprocessorFlag: "CUSTOM_FLAG", accessLevel: .package)
      @available(*, deprecated)
      \(protocolDeclaration)
      """,
      expandedSource: """

        @MainActor
        @available(*, deprecated)
        \(protocolDeclaration)

        #if CUSTOM_FLAG
        package class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            package init() {
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  // MARK: - `threadSafe` argument

  func testMacroWithThreadSafeArgument() {
    let protocolDeclaration = """
      protocol ServiceProtocol {
          var data: Data { get }
          func fetch(text: String) async -> Decimal
          func isReady() -> Bool
          func load() async throws
      }
      """

    assertMacroExpansion(
      """
      @Spyable(threadSafe: true)
      \(protocolDeclaration)
      """,
      expandedSource: """

        protocol ServiceProtocol {
            var data: Data { get }
            func fetch(text: String) async -> Decimal
            func isReady() -> Bool
            func load() async throws
        }

        #if DEBUG
        class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLock = NSLock()
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            var data: Data {
                get {
                    underlyingData
                }
                set {
                    underlyingData = newValue
                }
            }
            private var __spyable_underlyingData: (Data)!
            var underlyingData: (Data)! {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_underlyingData
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_underlyingData = newValue
                }
            }
            private var __spyable_fetchTextCallsCount: Int = 0
            var fetchTextCallsCount: Int {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextCallsCount
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextCallsCount = newValue
                }
            }
            var fetchTextCalled: Bool {
                return fetchTextCallsCount > 0
            }
            private var __spyable_fetchTextReceivedText: String?
            var fetchTextReceivedText: String? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReceivedText
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReceivedText = newValue
                }
            }
            private var __spyable_fetchTextReceivedInvocations: [String] = []
            var fetchTextReceivedInvocations: [String] {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReceivedInvocations
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReceivedInvocations = newValue
                }
            }
            private var __spyable_fetchTextReturnValue: Decimal!
            var fetchTextReturnValue: Decimal! {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReturnValue
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReturnValue = newValue
                }
            }
            private var __spyable_fetchTextClosure: ((String) async -> Decimal)?
            var fetchTextClosure: ((String) async -> Decimal)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextClosure
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextClosure = newValue
                }
            }
            func fetch(text: String) async -> Decimal {
                __spyableLock.lock()
                __spyable_fetchTextCallsCount += 1
                __spyable_fetchTextReceivedText = (text)
                __spyable_fetchTextReceivedInvocations.append((text))
                let fetchTextClosure: ((String) async -> Decimal)? = __spyable_fetchTextClosure
                let fetchTextReturnValue: Decimal! = __spyable_fetchTextReturnValue
                __spyableLock.unlock()
                if fetchTextClosure != nil {
                    return await fetchTextClosure!(text)
                } else {
                    return fetchTextReturnValue
                }
            }
            private var __spyable_isReadyCallsCount: Int = 0
            var isReadyCallsCount: Int {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_isReadyCallsCount
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_isReadyCallsCount = newValue
                }
            }
            var isReadyCalled: Bool {
                return isReadyCallsCount > 0
            }
            private var __spyable_isReadyReturnValue: Bool!
            var isReadyReturnValue: Bool! {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_isReadyReturnValue
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_isReadyReturnValue = newValue
                }
            }
            private var __spyable_isReadyClosure: (() -> Bool)?
            var isReadyClosure: (() -> Bool)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_isReadyClosure
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_isReadyClosure = newValue
                }
            }
            func isReady() -> Bool {
                __spyableLock.lock()
                __spyable_isReadyCallsCount += 1
                let isReadyClosure: (() -> Bool)? = __spyable_isReadyClosure
                let isReadyReturnValue: Bool! = __spyable_isReadyReturnValue
                __spyableLock.unlock()
                if isReadyClosure != nil {
                    return isReadyClosure!()
                } else {
                    return isReadyReturnValue
                }
            }
            private var __spyable_loadCallsCount: Int = 0
            var loadCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "load");
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_loadCallsCount
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_loadCallsCount = newValue
                }
            }
            var loadCalled: Bool {
                return loadCallsCount > 0
            }
            private var __spyable_loadThrowableError: (any Error)?
            var loadThrowableError: (any Error)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_loadThrowableError
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_loadThrowableError = newValue
                }
            }
            private var __spyable_loadClosure: (() async throws -> Void)?
            var loadClosure: (() async throws -> Void)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_loadClosure
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_loadClosure = newValue
                }
            }
            func load() async throws {
                __spyableLedger?.record(self, "load", "ServiceProtocolSpy.load()")
                __spyableLock.lock()
                __spyable_loadCallsCount += 1
                let loadThrowableError: (any Error)? = __spyable_loadThrowableError
                let loadClosure: (() async throws -> Void)? = __spyable_loadClosure
                __spyableLock.unlock()
                if let loadThrowableError {
                    throw loadThrowableError
                }
                try await loadClosure?()
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithThreadSafeArgumentAndPublicAccessLevel() {
    let protocolDeclaration = """
      protocol ServiceProtocol {
          func fetch(text: String) -> Int
      }
      """

    assertMacroExpansion(
      """
      @Spyable(accessLevel: .public, threadSafe: true)
      \(protocolDeclaration)
      """,
      expandedSource: """

        protocol ServiceProtocol {
            func fetch(text: String) -> Int
        }

        #if DEBUG
        public class ServiceProtocolSpy: ServiceProtocol, @unchecked Sendable {
            public init() {
            }
            private let __spyableLock = NSLock()
            private var __spyable_fetchTextCallsCount: Int = 0
            public var fetchTextCallsCount: Int {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextCallsCount
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextCallsCount = newValue
                }
            }
            public var fetchTextCalled: Bool {
                return fetchTextCallsCount > 0
            }
            private var __spyable_fetchTextReceivedText: String?
            public var fetchTextReceivedText: String? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReceivedText
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReceivedText = newValue
                }
            }
            private var __spyable_fetchTextReceivedInvocations: [String] = []
            public var fetchTextReceivedInvocations: [String] {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReceivedInvocations
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReceivedInvocations = newValue
                }
            }
            private var __spyable_fetchTextReturnValue: Int!
            public var fetchTextReturnValue: Int! {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextReturnValue
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextReturnValue = newValue
                }
            }
            private var __spyable_fetchTextClosure: ((String) -> Int)?
            public var fetchTextClosure: ((String) -> Int)? {
                get {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    return __spyable_fetchTextClosure
                }
                set {
                    __spyableLock.lock();
                    defer {
                        __spyableLock.unlock()
                    };
                    __spyable_fetchTextClosure = newValue
                }
            }
            public
            func fetch(text: String) -> Int {
                __spyableLock.lock()
                __spyable_fetchTextCallsCount += 1
                __spyable_fetchTextReceivedText = (text)
                __spyable_fetchTextReceivedInvocations.append((text))
                let fetchTextClosure: ((String) -> Int)? = __spyable_fetchTextClosure
                let fetchTextReturnValue: Int! = __spyable_fetchTextReturnValue
                __spyableLock.unlock()
                if fetchTextClosure != nil {
                    return fetchTextClosure!(text)
                } else {
                    return fetchTextReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testMacroWithThreadSafeArgumentFromVariable() {
    let protocolDeclaration = "protocol MyProtocol {}"

    assertMacroExpansion(
      """
      let myCustomFlag = true

      @Spyable(threadSafe: myCustomFlag)
      \(protocolDeclaration)
      """,
      expandedSource: """
        let myCustomFlag = true
        \(protocolDeclaration)

        #if DEBUG
        class MyProtocolSpy: MyProtocol, @unchecked Sendable {
            init() {
            }
        }
        #endif
        """,
      diagnostics: [
        DiagnosticSpec(
          message: "The `threadSafe` argument requires a static boolean literal",
          line: 3,
          column: 1
        )
      ],
      macros: sut
    )
  }

  func testPolymorphismOverloadedMethodsWithDifferentReturnTypesOnly() {
    let protocolDeclaration = """
      protocol OverloadedReturnTypesProtocol {
        func doSomething()
        func doSomething() -> Int
        func doSomething() -> String?
        func doSomething() -> [String]
        func doSomething() -> [String: Int]
        func doSomething() -> (Int, Int)
        func doSomething() -> (Int, Bool)
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class OverloadedReturnTypesProtocolSpy: OverloadedReturnTypesProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_doSomethingCallsCount: Int = 0
            var doSomethingCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "doSomething")
                    return __spyable_doSomethingCallsCount
                }
                set {
                    __spyable_doSomethingCallsCount = newValue
                }
            }
            var doSomethingCalled: Bool {
                return doSomethingCallsCount > 0
            }
            var doSomethingClosure: (() -> Void)?
            func doSomething() {
                __spyableLedger?.record(self, "doSomething", "OverloadedReturnTypesProtocolSpy.doSomething()")
                __spyable_doSomethingCallsCount += 1
                doSomethingClosure?()
            }
            var doSomethingIntCallsCount = 0
            var doSomethingIntCalled: Bool {
                return doSomethingIntCallsCount > 0
            }
            var doSomethingIntReturnValue: Int!
            var doSomethingIntClosure: (() -> Int)?
            func doSomething() -> Int {
                doSomethingIntCallsCount += 1
                if doSomethingIntClosure != nil {
                    return doSomethingIntClosure!()
                } else {
                    return doSomethingIntReturnValue
                }
            }
            var doSomethingOptionalStringCallsCount = 0
            var doSomethingOptionalStringCalled: Bool {
                return doSomethingOptionalStringCallsCount > 0
            }
            var doSomethingOptionalStringReturnValue: String?
            var doSomethingOptionalStringClosure: (() -> String?)?
            func doSomething() -> String? {
                doSomethingOptionalStringCallsCount += 1
                if doSomethingOptionalStringClosure != nil {
                    return doSomethingOptionalStringClosure!()
                } else {
                    return doSomethingOptionalStringReturnValue
                }
            }
            var doSomethingArrayStringCallsCount = 0
            var doSomethingArrayStringCalled: Bool {
                return doSomethingArrayStringCallsCount > 0
            }
            var doSomethingArrayStringReturnValue: [String]!
            var doSomethingArrayStringClosure: (() -> [String])?
            func doSomething() -> [String] {
                doSomethingArrayStringCallsCount += 1
                if doSomethingArrayStringClosure != nil {
                    return doSomethingArrayStringClosure!()
                } else {
                    return doSomethingArrayStringReturnValue
                }
            }
            var doSomethingDictionaryStringIntCallsCount = 0
            var doSomethingDictionaryStringIntCalled: Bool {
                return doSomethingDictionaryStringIntCallsCount > 0
            }
            var doSomethingDictionaryStringIntReturnValue: [String: Int]!
            var doSomethingDictionaryStringIntClosure: (() -> [String: Int])?
            func doSomething() -> [String: Int] {
                doSomethingDictionaryStringIntCallsCount += 1
                if doSomethingDictionaryStringIntClosure != nil {
                    return doSomethingDictionaryStringIntClosure!()
                } else {
                    return doSomethingDictionaryStringIntReturnValue
                }
            }
            var doSomethingIntIntCallsCount = 0
            var doSomethingIntIntCalled: Bool {
                return doSomethingIntIntCallsCount > 0
            }
            var doSomethingIntIntReturnValue: (Int, Int)!
            var doSomethingIntIntClosure: (() -> (Int, Int))?
            func doSomething() -> (Int, Int) {
                doSomethingIntIntCallsCount += 1
                if doSomethingIntIntClosure != nil {
                    return doSomethingIntIntClosure!()
                } else {
                    return doSomethingIntIntReturnValue
                }
            }
            var doSomethingIntBoolCallsCount = 0
            var doSomethingIntBoolCalled: Bool {
                return doSomethingIntBoolCallsCount > 0
            }
            var doSomethingIntBoolReturnValue: (Int, Bool)!
            var doSomethingIntBoolClosure: (() -> (Int, Bool))?
            func doSomething() -> (Int, Bool) {
                doSomethingIntBoolCallsCount += 1
                if doSomethingIntBoolClosure != nil {
                    return doSomethingIntBoolClosure!()
                } else {
                    return doSomethingIntBoolReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismOverloadedMethodsWithDifferentParameterTypes() {
    let protocolDeclaration = """
      protocol OverloadedParameterTypesProtocol {
        func compute(value: Int)
        func compute(for id: String)
        func compute(for ids: Set<String>) -> [String]
        func compute(value: Int) -> Bool
        func compute(value: Int?) -> [Int: String]
        func compute(value: String?) -> Bool
        func compute(value: Bool) -> Bool
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class OverloadedParameterTypesProtocolSpy: OverloadedParameterTypesProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_computeValueIntCallsCount: Int = 0
            var computeValueIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "computeValueInt")
                    return __spyable_computeValueIntCallsCount
                }
                set {
                    __spyable_computeValueIntCallsCount = newValue
                }
            }
            var computeValueIntCalled: Bool {
                return computeValueIntCallsCount > 0
            }
            private var __spyable_computeValueIntReceivedValue: Int?
            var computeValueIntReceivedValue: Int? {
                get {
                    __spyableLedger?.markVerified(self, "computeValueInt")
                    return __spyable_computeValueIntReceivedValue
                }
                set {
                    __spyable_computeValueIntReceivedValue = newValue
                }
            }
            private var __spyable_computeValueIntReceivedInvocations: [Int] = []
            var computeValueIntReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "computeValueInt")
                    return __spyable_computeValueIntReceivedInvocations
                }
                set {
                    __spyable_computeValueIntReceivedInvocations = newValue
                }
            }
            var computeValueIntClosure: ((Int) -> Void)?
            func compute(value: Int) {
                __spyableLedger?.record(self, "computeValueInt", "OverloadedParameterTypesProtocolSpy.compute(value: Int)")
                __spyable_computeValueIntCallsCount += 1
                __spyable_computeValueIntReceivedValue = (value)
                __spyable_computeValueIntReceivedInvocations.append((value))
                computeValueIntClosure?(value)
            }
            private var __spyable_computeForStringCallsCount: Int = 0
            var computeForStringCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "computeForString")
                    return __spyable_computeForStringCallsCount
                }
                set {
                    __spyable_computeForStringCallsCount = newValue
                }
            }
            var computeForStringCalled: Bool {
                return computeForStringCallsCount > 0
            }
            private var __spyable_computeForStringReceivedId: String?
            var computeForStringReceivedId: String? {
                get {
                    __spyableLedger?.markVerified(self, "computeForString")
                    return __spyable_computeForStringReceivedId
                }
                set {
                    __spyable_computeForStringReceivedId = newValue
                }
            }
            private var __spyable_computeForStringReceivedInvocations: [String] = []
            var computeForStringReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "computeForString")
                    return __spyable_computeForStringReceivedInvocations
                }
                set {
                    __spyable_computeForStringReceivedInvocations = newValue
                }
            }
            var computeForStringClosure: ((String) -> Void)?
            func compute(for id: String) {
                __spyableLedger?.record(self, "computeForString", "OverloadedParameterTypesProtocolSpy.compute(for: String)")
                __spyable_computeForStringCallsCount += 1
                __spyable_computeForStringReceivedId = (id)
                __spyable_computeForStringReceivedInvocations.append((id))
                computeForStringClosure?(id)
            }
            var computeForSetStringArrayStringCallsCount = 0
            var computeForSetStringArrayStringCalled: Bool {
                return computeForSetStringArrayStringCallsCount > 0
            }
            var computeForSetStringArrayStringReceivedIds: Set<String>?
            var computeForSetStringArrayStringReceivedInvocations: [Set<String>] = []
            var computeForSetStringArrayStringReturnValue: [String]!
            var computeForSetStringArrayStringClosure: ((Set<String>) -> [String])?
            func compute(for ids: Set<String>) -> [String] {
                computeForSetStringArrayStringCallsCount += 1
                computeForSetStringArrayStringReceivedIds = (ids)
                computeForSetStringArrayStringReceivedInvocations.append((ids))
                if computeForSetStringArrayStringClosure != nil {
                    return computeForSetStringArrayStringClosure!(ids)
                } else {
                    return computeForSetStringArrayStringReturnValue
                }
            }
            var computeValueIntBoolCallsCount = 0
            var computeValueIntBoolCalled: Bool {
                return computeValueIntBoolCallsCount > 0
            }
            var computeValueIntBoolReceivedValue: Int?
            var computeValueIntBoolReceivedInvocations: [Int] = []
            var computeValueIntBoolReturnValue: Bool!
            var computeValueIntBoolClosure: ((Int) -> Bool)?
            func compute(value: Int) -> Bool {
                computeValueIntBoolCallsCount += 1
                computeValueIntBoolReceivedValue = (value)
                computeValueIntBoolReceivedInvocations.append((value))
                if computeValueIntBoolClosure != nil {
                    return computeValueIntBoolClosure!(value)
                } else {
                    return computeValueIntBoolReturnValue
                }
            }
            var computeValueOptionalIntDictionaryIntStringCallsCount = 0
            var computeValueOptionalIntDictionaryIntStringCalled: Bool {
                return computeValueOptionalIntDictionaryIntStringCallsCount > 0
            }
            var computeValueOptionalIntDictionaryIntStringReceivedValue: Int?
            var computeValueOptionalIntDictionaryIntStringReceivedInvocations: [Int?] = []
            var computeValueOptionalIntDictionaryIntStringReturnValue: [Int: String]!
            var computeValueOptionalIntDictionaryIntStringClosure: ((Int?) -> [Int: String])?
            func compute(value: Int?) -> [Int: String] {
                computeValueOptionalIntDictionaryIntStringCallsCount += 1
                computeValueOptionalIntDictionaryIntStringReceivedValue = (value)
                computeValueOptionalIntDictionaryIntStringReceivedInvocations.append((value))
                if computeValueOptionalIntDictionaryIntStringClosure != nil {
                    return computeValueOptionalIntDictionaryIntStringClosure!(value)
                } else {
                    return computeValueOptionalIntDictionaryIntStringReturnValue
                }
            }
            var computeValueOptionalStringBoolCallsCount = 0
            var computeValueOptionalStringBoolCalled: Bool {
                return computeValueOptionalStringBoolCallsCount > 0
            }
            var computeValueOptionalStringBoolReceivedValue: String?
            var computeValueOptionalStringBoolReceivedInvocations: [String?] = []
            var computeValueOptionalStringBoolReturnValue: Bool!
            var computeValueOptionalStringBoolClosure: ((String?) -> Bool)?
            func compute(value: String?) -> Bool {
                computeValueOptionalStringBoolCallsCount += 1
                computeValueOptionalStringBoolReceivedValue = (value)
                computeValueOptionalStringBoolReceivedInvocations.append((value))
                if computeValueOptionalStringBoolClosure != nil {
                    return computeValueOptionalStringBoolClosure!(value)
                } else {
                    return computeValueOptionalStringBoolReturnValue
                }
            }
            var computeValueBoolBoolCallsCount = 0
            var computeValueBoolBoolCalled: Bool {
                return computeValueBoolBoolCallsCount > 0
            }
            var computeValueBoolBoolReceivedValue: Bool?
            var computeValueBoolBoolReceivedInvocations: [Bool] = []
            var computeValueBoolBoolReturnValue: Bool!
            var computeValueBoolBoolClosure: ((Bool) -> Bool)?
            func compute(value: Bool) -> Bool {
                computeValueBoolBoolCallsCount += 1
                computeValueBoolBoolReceivedValue = (value)
                computeValueBoolBoolReceivedInvocations.append((value))
                if computeValueBoolBoolClosure != nil {
                    return computeValueBoolBoolClosure!(value)
                } else {
                    return computeValueBoolBoolReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismOverloadedMethodsWithComplexTypes() {
    let protocolDeclaration = """
      protocol ComplexTypesProtocol {
        func doSomething() -> Set<Int>
        func doSomething() -> Set<Int?>
        func doSomething() -> Set<Int>?
        func doSomething() -> Result<String, Error>?
        func doSomething() -> Set<Int?>?
        
        func compute(value: Int) -> Result<String, Error>
        func compute(value: Int) -> Set<String>
        func compute(value: Int) -> Set<String?>
        func compute(value: Int) -> Set<String>?
        func compute(value: Int) -> Set<String?>?
        func compute(value: Int?) -> (String, Bool)
        func compute(value: Int?) -> (String, String?)
        func compute(value: Set<Int?>?) -> [Int: String]
        func compute(value: Set<Int?>) -> [Int: String]
        func compute(value: Set<Int>) -> [Int: String]
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class ComplexTypesProtocolSpy: ComplexTypesProtocol, @unchecked Sendable {
            init() {
            }
            var doSomethingSetIntCallsCount = 0
            var doSomethingSetIntCalled: Bool {
                return doSomethingSetIntCallsCount > 0
            }
            var doSomethingSetIntReturnValue: Set<Int>!
            var doSomethingSetIntClosure: (() -> Set<Int>)?
            func doSomething() -> Set<Int> {
                doSomethingSetIntCallsCount += 1
                if doSomethingSetIntClosure != nil {
                    return doSomethingSetIntClosure!()
                } else {
                    return doSomethingSetIntReturnValue
                }
            }
            var doSomethingSetIntOptionalCallsCount = 0
            var doSomethingSetIntOptionalCalled: Bool {
                return doSomethingSetIntOptionalCallsCount > 0
            }
            var doSomethingSetIntOptionalReturnValue: Set<Int?>!
            var doSomethingSetIntOptionalClosure: (() -> Set<Int?>)?
            func doSomething() -> Set<Int?> {
                doSomethingSetIntOptionalCallsCount += 1
                if doSomethingSetIntOptionalClosure != nil {
                    return doSomethingSetIntOptionalClosure!()
                } else {
                    return doSomethingSetIntOptionalReturnValue
                }
            }
            var doSomethingOptionalSetIntCallsCount = 0
            var doSomethingOptionalSetIntCalled: Bool {
                return doSomethingOptionalSetIntCallsCount > 0
            }
            var doSomethingOptionalSetIntReturnValue: Set<Int>?
            var doSomethingOptionalSetIntClosure: (() -> Set<Int>?)?
            func doSomething() -> Set<Int>? {
                doSomethingOptionalSetIntCallsCount += 1
                if doSomethingOptionalSetIntClosure != nil {
                    return doSomethingOptionalSetIntClosure!()
                } else {
                    return doSomethingOptionalSetIntReturnValue
                }
            }
            var doSomethingOptionalResultStringErrorCallsCount = 0
            var doSomethingOptionalResultStringErrorCalled: Bool {
                return doSomethingOptionalResultStringErrorCallsCount > 0
            }
            var doSomethingOptionalResultStringErrorReturnValue: Result<String, Error>?
            var doSomethingOptionalResultStringErrorClosure: (() -> Result<String, Error>?)?
            func doSomething() -> Result<String, Error>? {
                doSomethingOptionalResultStringErrorCallsCount += 1
                if doSomethingOptionalResultStringErrorClosure != nil {
                    return doSomethingOptionalResultStringErrorClosure!()
                } else {
                    return doSomethingOptionalResultStringErrorReturnValue
                }
            }
            var doSomethingOptionalSetIntOptionalCallsCount = 0
            var doSomethingOptionalSetIntOptionalCalled: Bool {
                return doSomethingOptionalSetIntOptionalCallsCount > 0
            }
            var doSomethingOptionalSetIntOptionalReturnValue: Set<Int?>?
            var doSomethingOptionalSetIntOptionalClosure: (() -> Set<Int?>?)?
            func doSomething() -> Set<Int?>? {
                doSomethingOptionalSetIntOptionalCallsCount += 1
                if doSomethingOptionalSetIntOptionalClosure != nil {
                    return doSomethingOptionalSetIntOptionalClosure!()
                } else {
                    return doSomethingOptionalSetIntOptionalReturnValue
                }
            }
            var computeValueIntResultStringErrorCallsCount = 0
            var computeValueIntResultStringErrorCalled: Bool {
                return computeValueIntResultStringErrorCallsCount > 0
            }
            var computeValueIntResultStringErrorReceivedValue: Int?
            var computeValueIntResultStringErrorReceivedInvocations: [Int] = []
            var computeValueIntResultStringErrorReturnValue: Result<String, Error>!
            var computeValueIntResultStringErrorClosure: ((Int) -> Result<String, Error>)?

            func compute(value: Int) -> Result<String, Error> {
                computeValueIntResultStringErrorCallsCount += 1
                computeValueIntResultStringErrorReceivedValue = (value)
                computeValueIntResultStringErrorReceivedInvocations.append((value))
                if computeValueIntResultStringErrorClosure != nil {
                    return computeValueIntResultStringErrorClosure!(value)
                } else {
                    return computeValueIntResultStringErrorReturnValue
                }
            }
            var computeValueIntSetStringCallsCount = 0
            var computeValueIntSetStringCalled: Bool {
                return computeValueIntSetStringCallsCount > 0
            }
            var computeValueIntSetStringReceivedValue: Int?
            var computeValueIntSetStringReceivedInvocations: [Int] = []
            var computeValueIntSetStringReturnValue: Set<String>!
            var computeValueIntSetStringClosure: ((Int) -> Set<String>)?
            func compute(value: Int) -> Set<String> {
                computeValueIntSetStringCallsCount += 1
                computeValueIntSetStringReceivedValue = (value)
                computeValueIntSetStringReceivedInvocations.append((value))
                if computeValueIntSetStringClosure != nil {
                    return computeValueIntSetStringClosure!(value)
                } else {
                    return computeValueIntSetStringReturnValue
                }
            }
            var computeValueIntSetStringOptionalCallsCount = 0
            var computeValueIntSetStringOptionalCalled: Bool {
                return computeValueIntSetStringOptionalCallsCount > 0
            }
            var computeValueIntSetStringOptionalReceivedValue: Int?
            var computeValueIntSetStringOptionalReceivedInvocations: [Int] = []
            var computeValueIntSetStringOptionalReturnValue: Set<String?>!
            var computeValueIntSetStringOptionalClosure: ((Int) -> Set<String?>)?
            func compute(value: Int) -> Set<String?> {
                computeValueIntSetStringOptionalCallsCount += 1
                computeValueIntSetStringOptionalReceivedValue = (value)
                computeValueIntSetStringOptionalReceivedInvocations.append((value))
                if computeValueIntSetStringOptionalClosure != nil {
                    return computeValueIntSetStringOptionalClosure!(value)
                } else {
                    return computeValueIntSetStringOptionalReturnValue
                }
            }
            var computeValueIntOptionalSetStringCallsCount = 0
            var computeValueIntOptionalSetStringCalled: Bool {
                return computeValueIntOptionalSetStringCallsCount > 0
            }
            var computeValueIntOptionalSetStringReceivedValue: Int?
            var computeValueIntOptionalSetStringReceivedInvocations: [Int] = []
            var computeValueIntOptionalSetStringReturnValue: Set<String>?
            var computeValueIntOptionalSetStringClosure: ((Int) -> Set<String>?)?
            func compute(value: Int) -> Set<String>? {
                computeValueIntOptionalSetStringCallsCount += 1
                computeValueIntOptionalSetStringReceivedValue = (value)
                computeValueIntOptionalSetStringReceivedInvocations.append((value))
                if computeValueIntOptionalSetStringClosure != nil {
                    return computeValueIntOptionalSetStringClosure!(value)
                } else {
                    return computeValueIntOptionalSetStringReturnValue
                }
            }
            var computeValueIntOptionalSetStringOptionalCallsCount = 0
            var computeValueIntOptionalSetStringOptionalCalled: Bool {
                return computeValueIntOptionalSetStringOptionalCallsCount > 0
            }
            var computeValueIntOptionalSetStringOptionalReceivedValue: Int?
            var computeValueIntOptionalSetStringOptionalReceivedInvocations: [Int] = []
            var computeValueIntOptionalSetStringOptionalReturnValue: Set<String?>?
            var computeValueIntOptionalSetStringOptionalClosure: ((Int) -> Set<String?>?)?
            func compute(value: Int) -> Set<String?>? {
                computeValueIntOptionalSetStringOptionalCallsCount += 1
                computeValueIntOptionalSetStringOptionalReceivedValue = (value)
                computeValueIntOptionalSetStringOptionalReceivedInvocations.append((value))
                if computeValueIntOptionalSetStringOptionalClosure != nil {
                    return computeValueIntOptionalSetStringOptionalClosure!(value)
                } else {
                    return computeValueIntOptionalSetStringOptionalReturnValue
                }
            }
            var computeValueOptionalIntStringBoolCallsCount = 0
            var computeValueOptionalIntStringBoolCalled: Bool {
                return computeValueOptionalIntStringBoolCallsCount > 0
            }
            var computeValueOptionalIntStringBoolReceivedValue: Int?
            var computeValueOptionalIntStringBoolReceivedInvocations: [Int?] = []
            var computeValueOptionalIntStringBoolReturnValue: (String, Bool)!
            var computeValueOptionalIntStringBoolClosure: ((Int?) -> (String, Bool))?
            func compute(value: Int?) -> (String, Bool) {
                computeValueOptionalIntStringBoolCallsCount += 1
                computeValueOptionalIntStringBoolReceivedValue = (value)
                computeValueOptionalIntStringBoolReceivedInvocations.append((value))
                if computeValueOptionalIntStringBoolClosure != nil {
                    return computeValueOptionalIntStringBoolClosure!(value)
                } else {
                    return computeValueOptionalIntStringBoolReturnValue
                }
            }
            var computeValueOptionalIntStringStringOptionalCallsCount = 0
            var computeValueOptionalIntStringStringOptionalCalled: Bool {
                return computeValueOptionalIntStringStringOptionalCallsCount > 0
            }
            var computeValueOptionalIntStringStringOptionalReceivedValue: Int?
            var computeValueOptionalIntStringStringOptionalReceivedInvocations: [Int?] = []
            var computeValueOptionalIntStringStringOptionalReturnValue: (String, String?)!
            var computeValueOptionalIntStringStringOptionalClosure: ((Int?) -> (String, String?))?
            func compute(value: Int?) -> (String, String?) {
                computeValueOptionalIntStringStringOptionalCallsCount += 1
                computeValueOptionalIntStringStringOptionalReceivedValue = (value)
                computeValueOptionalIntStringStringOptionalReceivedInvocations.append((value))
                if computeValueOptionalIntStringStringOptionalClosure != nil {
                    return computeValueOptionalIntStringStringOptionalClosure!(value)
                } else {
                    return computeValueOptionalIntStringStringOptionalReturnValue
                }
            }
            var computeValueOptionalSetIntOptionalDictionaryIntStringCallsCount = 0
            var computeValueOptionalSetIntOptionalDictionaryIntStringCalled: Bool {
                return computeValueOptionalSetIntOptionalDictionaryIntStringCallsCount > 0
            }
            var computeValueOptionalSetIntOptionalDictionaryIntStringReceivedValue: Set<Int?>?
            var computeValueOptionalSetIntOptionalDictionaryIntStringReceivedInvocations: [Set<Int?>?] = []
            var computeValueOptionalSetIntOptionalDictionaryIntStringReturnValue: [Int: String]!
            var computeValueOptionalSetIntOptionalDictionaryIntStringClosure: ((Set<Int?>?) -> [Int: String])?
            func compute(value: Set<Int?>?) -> [Int: String] {
                computeValueOptionalSetIntOptionalDictionaryIntStringCallsCount += 1
                computeValueOptionalSetIntOptionalDictionaryIntStringReceivedValue = (value)
                computeValueOptionalSetIntOptionalDictionaryIntStringReceivedInvocations.append((value))
                if computeValueOptionalSetIntOptionalDictionaryIntStringClosure != nil {
                    return computeValueOptionalSetIntOptionalDictionaryIntStringClosure!(value)
                } else {
                    return computeValueOptionalSetIntOptionalDictionaryIntStringReturnValue
                }
            }
            var computeValueSetIntOptionalDictionaryIntStringCallsCount = 0
            var computeValueSetIntOptionalDictionaryIntStringCalled: Bool {
                return computeValueSetIntOptionalDictionaryIntStringCallsCount > 0
            }
            var computeValueSetIntOptionalDictionaryIntStringReceivedValue: Set<Int?>?
            var computeValueSetIntOptionalDictionaryIntStringReceivedInvocations: [Set<Int?>] = []
            var computeValueSetIntOptionalDictionaryIntStringReturnValue: [Int: String]!
            var computeValueSetIntOptionalDictionaryIntStringClosure: ((Set<Int?>) -> [Int: String])?
            func compute(value: Set<Int?>) -> [Int: String] {
                computeValueSetIntOptionalDictionaryIntStringCallsCount += 1
                computeValueSetIntOptionalDictionaryIntStringReceivedValue = (value)
                computeValueSetIntOptionalDictionaryIntStringReceivedInvocations.append((value))
                if computeValueSetIntOptionalDictionaryIntStringClosure != nil {
                    return computeValueSetIntOptionalDictionaryIntStringClosure!(value)
                } else {
                    return computeValueSetIntOptionalDictionaryIntStringReturnValue
                }
            }
            var computeValueSetIntDictionaryIntStringCallsCount = 0
            var computeValueSetIntDictionaryIntStringCalled: Bool {
                return computeValueSetIntDictionaryIntStringCallsCount > 0
            }
            var computeValueSetIntDictionaryIntStringReceivedValue: Set<Int>?
            var computeValueSetIntDictionaryIntStringReceivedInvocations: [Set<Int>] = []
            var computeValueSetIntDictionaryIntStringReturnValue: [Int: String]!
            var computeValueSetIntDictionaryIntStringClosure: ((Set<Int>) -> [Int: String])?
            func compute(value: Set<Int>) -> [Int: String] {
                computeValueSetIntDictionaryIntStringCallsCount += 1
                computeValueSetIntDictionaryIntStringReceivedValue = (value)
                computeValueSetIntDictionaryIntStringReceivedInvocations.append((value))
                if computeValueSetIntDictionaryIntStringClosure != nil {
                    return computeValueSetIntDictionaryIntStringClosure!(value)
                } else {
                    return computeValueSetIntDictionaryIntStringReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismOverloadedMethodsWithOptionalTypes() {
    let protocolDeclaration = """
      protocol OptionalTypesProtocol {
        func compute(value: Int) -> Double?
        func compute(value: Int) -> [Int]
        func compute(value: Int?) -> [Int: String]
        func compute(value: String?) -> Bool
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class OptionalTypesProtocolSpy: OptionalTypesProtocol, @unchecked Sendable {
            init() {
            }
            var computeValueIntOptionalDoubleCallsCount = 0
            var computeValueIntOptionalDoubleCalled: Bool {
                return computeValueIntOptionalDoubleCallsCount > 0
            }
            var computeValueIntOptionalDoubleReceivedValue: Int?
            var computeValueIntOptionalDoubleReceivedInvocations: [Int] = []
            var computeValueIntOptionalDoubleReturnValue: Double?
            var computeValueIntOptionalDoubleClosure: ((Int) -> Double?)?
            func compute(value: Int) -> Double? {
                computeValueIntOptionalDoubleCallsCount += 1
                computeValueIntOptionalDoubleReceivedValue = (value)
                computeValueIntOptionalDoubleReceivedInvocations.append((value))
                if computeValueIntOptionalDoubleClosure != nil {
                    return computeValueIntOptionalDoubleClosure!(value)
                } else {
                    return computeValueIntOptionalDoubleReturnValue
                }
            }
            var computeValueIntArrayIntCallsCount = 0
            var computeValueIntArrayIntCalled: Bool {
                return computeValueIntArrayIntCallsCount > 0
            }
            var computeValueIntArrayIntReceivedValue: Int?
            var computeValueIntArrayIntReceivedInvocations: [Int] = []
            var computeValueIntArrayIntReturnValue: [Int]!
            var computeValueIntArrayIntClosure: ((Int) -> [Int])?
            func compute(value: Int) -> [Int] {
                computeValueIntArrayIntCallsCount += 1
                computeValueIntArrayIntReceivedValue = (value)
                computeValueIntArrayIntReceivedInvocations.append((value))
                if computeValueIntArrayIntClosure != nil {
                    return computeValueIntArrayIntClosure!(value)
                } else {
                    return computeValueIntArrayIntReturnValue
                }
            }
            var computeValueOptionalIntDictionaryIntStringCallsCount = 0
            var computeValueOptionalIntDictionaryIntStringCalled: Bool {
                return computeValueOptionalIntDictionaryIntStringCallsCount > 0
            }
            var computeValueOptionalIntDictionaryIntStringReceivedValue: Int?
            var computeValueOptionalIntDictionaryIntStringReceivedInvocations: [Int?] = []
            var computeValueOptionalIntDictionaryIntStringReturnValue: [Int: String]!
            var computeValueOptionalIntDictionaryIntStringClosure: ((Int?) -> [Int: String])?
            func compute(value: Int?) -> [Int: String] {
                computeValueOptionalIntDictionaryIntStringCallsCount += 1
                computeValueOptionalIntDictionaryIntStringReceivedValue = (value)
                computeValueOptionalIntDictionaryIntStringReceivedInvocations.append((value))
                if computeValueOptionalIntDictionaryIntStringClosure != nil {
                    return computeValueOptionalIntDictionaryIntStringClosure!(value)
                } else {
                    return computeValueOptionalIntDictionaryIntStringReturnValue
                }
            }
            var computeValueOptionalStringBoolCallsCount = 0
            var computeValueOptionalStringBoolCalled: Bool {
                return computeValueOptionalStringBoolCallsCount > 0
            }
            var computeValueOptionalStringBoolReceivedValue: String?
            var computeValueOptionalStringBoolReceivedInvocations: [String?] = []
            var computeValueOptionalStringBoolReturnValue: Bool!
            var computeValueOptionalStringBoolClosure: ((String?) -> Bool)?
            func compute(value: String?) -> Bool {
                computeValueOptionalStringBoolCallsCount += 1
                computeValueOptionalStringBoolReceivedValue = (value)
                computeValueOptionalStringBoolReceivedInvocations.append((value))
                if computeValueOptionalStringBoolClosure != nil {
                    return computeValueOptionalStringBoolClosure!(value)
                } else {
                    return computeValueOptionalStringBoolReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismMethodsWithGenericReturnTypes() {
    let protocolDeclaration = """
      protocol GenericReturnTypesProtocol {
        func baz(id: Int) -> any Equatable
        func baz(id: String) -> any Equatable
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class GenericReturnTypesProtocolSpy: GenericReturnTypesProtocol, @unchecked Sendable {
            init() {
            }
            var bazIdIntanyEquatableCallsCount = 0
            var bazIdIntanyEquatableCalled: Bool {
                return bazIdIntanyEquatableCallsCount > 0
            }
            var bazIdIntanyEquatableReceivedId: Int?
            var bazIdIntanyEquatableReceivedInvocations: [Int] = []
            var bazIdIntanyEquatableReturnValue: (any Equatable)!
            var bazIdIntanyEquatableClosure: ((Int) -> any Equatable)?
            func baz(id: Int) -> any Equatable {
                bazIdIntanyEquatableCallsCount += 1
                bazIdIntanyEquatableReceivedId = (id)
                bazIdIntanyEquatableReceivedInvocations.append((id))
                if bazIdIntanyEquatableClosure != nil {
                    return bazIdIntanyEquatableClosure!(id)
                } else {
                    return bazIdIntanyEquatableReturnValue
                }
            }
            var bazIdStringanyEquatableCallsCount = 0
            var bazIdStringanyEquatableCalled: Bool {
                return bazIdStringanyEquatableCallsCount > 0
            }
            var bazIdStringanyEquatableReceivedId: String?
            var bazIdStringanyEquatableReceivedInvocations: [String] = []
            var bazIdStringanyEquatableReturnValue: (any Equatable)!
            var bazIdStringanyEquatableClosure: ((String) -> any Equatable)?
            func baz(id: String) -> any Equatable {
                bazIdStringanyEquatableCallsCount += 1
                bazIdStringanyEquatableReceivedId = (id)
                bazIdStringanyEquatableReceivedInvocations.append((id))
                if bazIdStringanyEquatableClosure != nil {
                    return bazIdStringanyEquatableClosure!(id)
                } else {
                    return bazIdStringanyEquatableReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithGenericConstraints() {
    let protocolDeclaration = """
      protocol GenericConstraintsProtocol {
        func process<T: Codable>(value: T)
        func process<T: Codable>(value: T) -> T
        func process<T: Codable>(value: T) -> String
        func transform<T: Codable & Hashable>(value: T)
        func transform<T: Codable & Hashable>(value: T) -> T
        func transform<T: Codable & Hashable>(value: T) -> [T]
        func convert<T>(value: T) where T: Equatable
        func convert<T>(value: T) -> T where T: Equatable
        func convert<T>(value: T) -> Bool where T: Equatable
        func convert<T, U>(value: T, other: U) where T: Equatable, U: Hashable
        func convert<T, U>(value: T, other: U) -> Bool where T: Equatable, U: Hashable
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class GenericConstraintsProtocolSpy: GenericConstraintsProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_processValueTCallsCount: Int = 0
            var processValueTCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processValueT")
                    return __spyable_processValueTCallsCount
                }
                set {
                    __spyable_processValueTCallsCount = newValue
                }
            }
            var processValueTCalled: Bool {
                return processValueTCallsCount > 0
            }
            private var __spyable_processValueTReceivedValue: Any?
            var processValueTReceivedValue: Any? {
                get {
                    __spyableLedger?.markVerified(self, "processValueT")
                    return __spyable_processValueTReceivedValue
                }
                set {
                    __spyable_processValueTReceivedValue = newValue
                }
            }
            private var __spyable_processValueTReceivedInvocations: [Any] = []
            var processValueTReceivedInvocations: [Any] {
                get {
                    __spyableLedger?.markVerified(self, "processValueT")
                    return __spyable_processValueTReceivedInvocations
                }
                set {
                    __spyable_processValueTReceivedInvocations = newValue
                }
            }
            var processValueTClosure: ((Any) -> Void)?
            func process<T: Codable>(value: T) {
                __spyableLedger?.record(self, "processValueT", "GenericConstraintsProtocolSpy.process(value: T)")
                __spyable_processValueTCallsCount += 1
                __spyable_processValueTReceivedValue = (value)
                __spyable_processValueTReceivedInvocations.append((value))
                processValueTClosure?(value)
            }
            var processValueTTCallsCount = 0
            var processValueTTCalled: Bool {
                return processValueTTCallsCount > 0
            }
            var processValueTTReceivedValue: Any?
            var processValueTTReceivedInvocations: [Any] = []
            var processValueTTReturnValue: Any!
            var processValueTTClosure: ((Any) -> Any)?
            func process<T: Codable>(value: T) -> T {
                processValueTTCallsCount += 1
                processValueTTReceivedValue = (value)
                processValueTTReceivedInvocations.append((value))
                if processValueTTClosure != nil {
                    return processValueTTClosure!(value) as! T
                } else {
                    return processValueTTReturnValue as! T
                }
            }
            var processValueTStringCallsCount = 0
            var processValueTStringCalled: Bool {
                return processValueTStringCallsCount > 0
            }
            var processValueTStringReceivedValue: Any?
            var processValueTStringReceivedInvocations: [Any] = []
            var processValueTStringReturnValue: String!
            var processValueTStringClosure: ((Any) -> String)?
            func process<T: Codable>(value: T) -> String {
                processValueTStringCallsCount += 1
                processValueTStringReceivedValue = (value)
                processValueTStringReceivedInvocations.append((value))
                if processValueTStringClosure != nil {
                    return processValueTStringClosure!(value)
                } else {
                    return processValueTStringReturnValue
                }
            }
            private var __spyable_transformValueTCallsCount: Int = 0
            var transformValueTCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "transformValueT")
                    return __spyable_transformValueTCallsCount
                }
                set {
                    __spyable_transformValueTCallsCount = newValue
                }
            }
            var transformValueTCalled: Bool {
                return transformValueTCallsCount > 0
            }
            private var __spyable_transformValueTReceivedValue: Any?
            var transformValueTReceivedValue: Any? {
                get {
                    __spyableLedger?.markVerified(self, "transformValueT")
                    return __spyable_transformValueTReceivedValue
                }
                set {
                    __spyable_transformValueTReceivedValue = newValue
                }
            }
            private var __spyable_transformValueTReceivedInvocations: [Any] = []
            var transformValueTReceivedInvocations: [Any] {
                get {
                    __spyableLedger?.markVerified(self, "transformValueT")
                    return __spyable_transformValueTReceivedInvocations
                }
                set {
                    __spyable_transformValueTReceivedInvocations = newValue
                }
            }
            var transformValueTClosure: ((Any) -> Void)?
            func transform<T: Codable & Hashable>(value: T) {
                __spyableLedger?.record(self, "transformValueT", "GenericConstraintsProtocolSpy.transform(value: T)")
                __spyable_transformValueTCallsCount += 1
                __spyable_transformValueTReceivedValue = (value)
                __spyable_transformValueTReceivedInvocations.append((value))
                transformValueTClosure?(value)
            }
            var transformValueTTCallsCount = 0
            var transformValueTTCalled: Bool {
                return transformValueTTCallsCount > 0
            }
            var transformValueTTReceivedValue: Any?
            var transformValueTTReceivedInvocations: [Any] = []
            var transformValueTTReturnValue: Any!
            var transformValueTTClosure: ((Any) -> Any)?
            func transform<T: Codable & Hashable>(value: T) -> T {
                transformValueTTCallsCount += 1
                transformValueTTReceivedValue = (value)
                transformValueTTReceivedInvocations.append((value))
                if transformValueTTClosure != nil {
                    return transformValueTTClosure!(value) as! T
                } else {
                    return transformValueTTReturnValue as! T
                }
            }
            var transformValueTArrayTCallsCount = 0
            var transformValueTArrayTCalled: Bool {
                return transformValueTArrayTCallsCount > 0
            }
            var transformValueTArrayTReceivedValue: Any?
            var transformValueTArrayTReceivedInvocations: [Any] = []
            var transformValueTArrayTReturnValue: [Any]!
            var transformValueTArrayTClosure: ((Any) -> [Any])?
            func transform<T: Codable & Hashable>(value: T) -> [T] {
                transformValueTArrayTCallsCount += 1
                transformValueTArrayTReceivedValue = (value)
                transformValueTArrayTReceivedInvocations.append((value))
                if transformValueTArrayTClosure != nil {
                    return transformValueTArrayTClosure!(value) as! [T]
                } else {
                    return transformValueTArrayTReturnValue as! [T]
                }
            }
            private var __spyable_convertValueTCallsCount: Int = 0
            var convertValueTCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "convertValueT")
                    return __spyable_convertValueTCallsCount
                }
                set {
                    __spyable_convertValueTCallsCount = newValue
                }
            }
            var convertValueTCalled: Bool {
                return convertValueTCallsCount > 0
            }
            private var __spyable_convertValueTReceivedValue: Any?
            var convertValueTReceivedValue: Any? {
                get {
                    __spyableLedger?.markVerified(self, "convertValueT")
                    return __spyable_convertValueTReceivedValue
                }
                set {
                    __spyable_convertValueTReceivedValue = newValue
                }
            }
            private var __spyable_convertValueTReceivedInvocations: [Any] = []
            var convertValueTReceivedInvocations: [Any] {
                get {
                    __spyableLedger?.markVerified(self, "convertValueT")
                    return __spyable_convertValueTReceivedInvocations
                }
                set {
                    __spyable_convertValueTReceivedInvocations = newValue
                }
            }
            var convertValueTClosure: ((Any) -> Void)?
            func convert<T>(value: T) where T: Equatable {
                __spyableLedger?.record(self, "convertValueT", "GenericConstraintsProtocolSpy.convert(value: T)")
                __spyable_convertValueTCallsCount += 1
                __spyable_convertValueTReceivedValue = (value)
                __spyable_convertValueTReceivedInvocations.append((value))
                convertValueTClosure?(value)
            }
            var convertValueTTCallsCount = 0
            var convertValueTTCalled: Bool {
                return convertValueTTCallsCount > 0
            }
            var convertValueTTReceivedValue: Any?
            var convertValueTTReceivedInvocations: [Any] = []
            var convertValueTTReturnValue: Any!
            var convertValueTTClosure: ((Any) -> Any)?
            func convert<T>(value: T) -> T where T: Equatable {
                convertValueTTCallsCount += 1
                convertValueTTReceivedValue = (value)
                convertValueTTReceivedInvocations.append((value))
                if convertValueTTClosure != nil {
                    return convertValueTTClosure!(value) as! T
                } else {
                    return convertValueTTReturnValue as! T
                }
            }
            var convertValueTBoolCallsCount = 0
            var convertValueTBoolCalled: Bool {
                return convertValueTBoolCallsCount > 0
            }
            var convertValueTBoolReceivedValue: Any?
            var convertValueTBoolReceivedInvocations: [Any] = []
            var convertValueTBoolReturnValue: Bool!
            var convertValueTBoolClosure: ((Any) -> Bool)?
            func convert<T>(value: T) -> Bool where T: Equatable {
                convertValueTBoolCallsCount += 1
                convertValueTBoolReceivedValue = (value)
                convertValueTBoolReceivedInvocations.append((value))
                if convertValueTBoolClosure != nil {
                    return convertValueTBoolClosure!(value)
                } else {
                    return convertValueTBoolReturnValue
                }
            }
            private var __spyable_convertValueTOtherUCallsCount: Int = 0
            var convertValueTOtherUCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "convertValueTOtherU")
                    return __spyable_convertValueTOtherUCallsCount
                }
                set {
                    __spyable_convertValueTOtherUCallsCount = newValue
                }
            }
            var convertValueTOtherUCalled: Bool {
                return convertValueTOtherUCallsCount > 0
            }
            private var __spyable_convertValueTOtherUReceivedArguments: (value: Any, other: Any)?
            var convertValueTOtherUReceivedArguments: (value: Any, other: Any)? {
                get {
                    __spyableLedger?.markVerified(self, "convertValueTOtherU")
                    return __spyable_convertValueTOtherUReceivedArguments
                }
                set {
                    __spyable_convertValueTOtherUReceivedArguments = newValue
                }
            }
            private var __spyable_convertValueTOtherUReceivedInvocations: [(value: Any, other: Any)] = []
            var convertValueTOtherUReceivedInvocations: [(value: Any, other: Any)] {
                get {
                    __spyableLedger?.markVerified(self, "convertValueTOtherU")
                    return __spyable_convertValueTOtherUReceivedInvocations
                }
                set {
                    __spyable_convertValueTOtherUReceivedInvocations = newValue
                }
            }
            var convertValueTOtherUClosure: ((Any, Any) -> Void)?
            func convert<T, U>(value: T, other: U) where T: Equatable, U: Hashable {
                __spyableLedger?.record(self, "convertValueTOtherU", "GenericConstraintsProtocolSpy.convert(value: T, other: U)")
                __spyable_convertValueTOtherUCallsCount += 1
                __spyable_convertValueTOtherUReceivedArguments = (value, other)
                __spyable_convertValueTOtherUReceivedInvocations.append((value, other))
                convertValueTOtherUClosure?(value, other)
            }
            var convertValueTOtherUBoolCallsCount = 0
            var convertValueTOtherUBoolCalled: Bool {
                return convertValueTOtherUBoolCallsCount > 0
            }
            var convertValueTOtherUBoolReceivedArguments: (value: Any, other: Any)?
            var convertValueTOtherUBoolReceivedInvocations: [(value: Any, other: Any)] = []
            var convertValueTOtherUBoolReturnValue: Bool!
            var convertValueTOtherUBoolClosure: ((Any, Any) -> Bool)?
            func convert<T, U>(value: T, other: U) -> Bool where T: Equatable, U: Hashable {
                convertValueTOtherUBoolCallsCount += 1
                convertValueTOtherUBoolReceivedArguments = (value, other)
                convertValueTOtherUBoolReceivedInvocations.append((value, other))
                if convertValueTOtherUBoolClosure != nil {
                    return convertValueTOtherUBoolClosure!(value, other)
                } else {
                    return convertValueTOtherUBoolReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithProtocolCompositions() {
    let protocolDeclaration = """
      protocol ProtocolCompositionsProtocol {
        func handle(value: Codable & Sendable)
        func handle(value: Codable & Sendable) -> String
        func handle(value: Codable & Sendable) -> Bool
        func handle(value: Codable & Hashable & Sendable)
        func handle(value: Codable & Hashable & Sendable) -> Int
        func create() -> Codable & Hashable
        func create() -> Codable & Sendable
        func create(with id: String) -> Codable & Hashable
        func create(with id: Int) -> Codable & Hashable
        func process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> Void)
        func process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> String)
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class ProtocolCompositionsProtocolSpy: ProtocolCompositionsProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_handleValueCodableSendableCallsCount: Int = 0
            var handleValueCodableSendableCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableSendable")
                    return __spyable_handleValueCodableSendableCallsCount
                }
                set {
                    __spyable_handleValueCodableSendableCallsCount = newValue
                }
            }
            var handleValueCodableSendableCalled: Bool {
                return handleValueCodableSendableCallsCount > 0
            }
            private var __spyable_handleValueCodableSendableReceivedValue: Codable & Sendable?
            var handleValueCodableSendableReceivedValue: Codable & Sendable? {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableSendable")
                    return __spyable_handleValueCodableSendableReceivedValue
                }
                set {
                    __spyable_handleValueCodableSendableReceivedValue = newValue
                }
            }
            private var __spyable_handleValueCodableSendableReceivedInvocations: [Codable & Sendable] = []
            var handleValueCodableSendableReceivedInvocations: [Codable & Sendable] {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableSendable")
                    return __spyable_handleValueCodableSendableReceivedInvocations
                }
                set {
                    __spyable_handleValueCodableSendableReceivedInvocations = newValue
                }
            }
            var handleValueCodableSendableClosure: ((Codable & Sendable) -> Void)?
            func handle(value: Codable & Sendable) {
                __spyableLedger?.record(self, "handleValueCodableSendable", "ProtocolCompositionsProtocolSpy.handle(value: Codable & Sendable)")
                __spyable_handleValueCodableSendableCallsCount += 1
                __spyable_handleValueCodableSendableReceivedValue = (value)
                __spyable_handleValueCodableSendableReceivedInvocations.append((value))
                handleValueCodableSendableClosure?(value)
            }
            var handleValueCodableSendableStringCallsCount = 0
            var handleValueCodableSendableStringCalled: Bool {
                return handleValueCodableSendableStringCallsCount > 0
            }
            var handleValueCodableSendableStringReceivedValue: Codable & Sendable?
            var handleValueCodableSendableStringReceivedInvocations: [Codable & Sendable] = []
            var handleValueCodableSendableStringReturnValue: String!
            var handleValueCodableSendableStringClosure: ((Codable & Sendable) -> String)?
            func handle(value: Codable & Sendable) -> String {
                handleValueCodableSendableStringCallsCount += 1
                handleValueCodableSendableStringReceivedValue = (value)
                handleValueCodableSendableStringReceivedInvocations.append((value))
                if handleValueCodableSendableStringClosure != nil {
                    return handleValueCodableSendableStringClosure!(value)
                } else {
                    return handleValueCodableSendableStringReturnValue
                }
            }
            var handleValueCodableSendableBoolCallsCount = 0
            var handleValueCodableSendableBoolCalled: Bool {
                return handleValueCodableSendableBoolCallsCount > 0
            }
            var handleValueCodableSendableBoolReceivedValue: Codable & Sendable?
            var handleValueCodableSendableBoolReceivedInvocations: [Codable & Sendable] = []
            var handleValueCodableSendableBoolReturnValue: Bool!
            var handleValueCodableSendableBoolClosure: ((Codable & Sendable) -> Bool)?
            func handle(value: Codable & Sendable) -> Bool {
                handleValueCodableSendableBoolCallsCount += 1
                handleValueCodableSendableBoolReceivedValue = (value)
                handleValueCodableSendableBoolReceivedInvocations.append((value))
                if handleValueCodableSendableBoolClosure != nil {
                    return handleValueCodableSendableBoolClosure!(value)
                } else {
                    return handleValueCodableSendableBoolReturnValue
                }
            }
            private var __spyable_handleValueCodableHashableSendableCallsCount: Int = 0
            var handleValueCodableHashableSendableCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableHashableSendable")
                    return __spyable_handleValueCodableHashableSendableCallsCount
                }
                set {
                    __spyable_handleValueCodableHashableSendableCallsCount = newValue
                }
            }
            var handleValueCodableHashableSendableCalled: Bool {
                return handleValueCodableHashableSendableCallsCount > 0
            }
            private var __spyable_handleValueCodableHashableSendableReceivedValue: Codable & Hashable & Sendable?
            var handleValueCodableHashableSendableReceivedValue: Codable & Hashable & Sendable? {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableHashableSendable")
                    return __spyable_handleValueCodableHashableSendableReceivedValue
                }
                set {
                    __spyable_handleValueCodableHashableSendableReceivedValue = newValue
                }
            }
            private var __spyable_handleValueCodableHashableSendableReceivedInvocations: [Codable & Hashable & Sendable] = []
            var handleValueCodableHashableSendableReceivedInvocations: [Codable & Hashable & Sendable] {
                get {
                    __spyableLedger?.markVerified(self, "handleValueCodableHashableSendable")
                    return __spyable_handleValueCodableHashableSendableReceivedInvocations
                }
                set {
                    __spyable_handleValueCodableHashableSendableReceivedInvocations = newValue
                }
            }
            var handleValueCodableHashableSendableClosure: ((Codable & Hashable & Sendable) -> Void)?
            func handle(value: Codable & Hashable & Sendable) {
                __spyableLedger?.record(self, "handleValueCodableHashableSendable", "ProtocolCompositionsProtocolSpy.handle(value: Codable & Hashable & Sendable)")
                __spyable_handleValueCodableHashableSendableCallsCount += 1
                __spyable_handleValueCodableHashableSendableReceivedValue = (value)
                __spyable_handleValueCodableHashableSendableReceivedInvocations.append((value))
                handleValueCodableHashableSendableClosure?(value)
            }
            var handleValueCodableHashableSendableIntCallsCount = 0
            var handleValueCodableHashableSendableIntCalled: Bool {
                return handleValueCodableHashableSendableIntCallsCount > 0
            }
            var handleValueCodableHashableSendableIntReceivedValue: Codable & Hashable & Sendable?
            var handleValueCodableHashableSendableIntReceivedInvocations: [Codable & Hashable & Sendable] = []
            var handleValueCodableHashableSendableIntReturnValue: Int!
            var handleValueCodableHashableSendableIntClosure: ((Codable & Hashable & Sendable) -> Int)?
            func handle(value: Codable & Hashable & Sendable) -> Int {
                handleValueCodableHashableSendableIntCallsCount += 1
                handleValueCodableHashableSendableIntReceivedValue = (value)
                handleValueCodableHashableSendableIntReceivedInvocations.append((value))
                if handleValueCodableHashableSendableIntClosure != nil {
                    return handleValueCodableHashableSendableIntClosure!(value)
                } else {
                    return handleValueCodableHashableSendableIntReturnValue
                }
            }
            var createCodableHashableCallsCount = 0
            var createCodableHashableCalled: Bool {
                return createCodableHashableCallsCount > 0
            }
            var createCodableHashableReturnValue: Codable & Hashable!
            var createCodableHashableClosure: (() -> Codable & Hashable)?
            func create() -> Codable & Hashable {
                createCodableHashableCallsCount += 1
                if createCodableHashableClosure != nil {
                    return createCodableHashableClosure!()
                } else {
                    return createCodableHashableReturnValue
                }
            }
            var createCodableSendableCallsCount = 0
            var createCodableSendableCalled: Bool {
                return createCodableSendableCallsCount > 0
            }
            var createCodableSendableReturnValue: Codable & Sendable!
            var createCodableSendableClosure: (() -> Codable & Sendable)?
            func create() -> Codable & Sendable {
                createCodableSendableCallsCount += 1
                if createCodableSendableClosure != nil {
                    return createCodableSendableClosure!()
                } else {
                    return createCodableSendableReturnValue
                }
            }
            var createWithStringCodableHashableCallsCount = 0
            var createWithStringCodableHashableCalled: Bool {
                return createWithStringCodableHashableCallsCount > 0
            }
            var createWithStringCodableHashableReceivedId: String?
            var createWithStringCodableHashableReceivedInvocations: [String] = []
            var createWithStringCodableHashableReturnValue: Codable & Hashable!
            var createWithStringCodableHashableClosure: ((String) -> Codable & Hashable)?
            func create(with id: String) -> Codable & Hashable {
                createWithStringCodableHashableCallsCount += 1
                createWithStringCodableHashableReceivedId = (id)
                createWithStringCodableHashableReceivedInvocations.append((id))
                if createWithStringCodableHashableClosure != nil {
                    return createWithStringCodableHashableClosure!(id)
                } else {
                    return createWithStringCodableHashableReturnValue
                }
            }
            var createWithIntCodableHashableCallsCount = 0
            var createWithIntCodableHashableCalled: Bool {
                return createWithIntCodableHashableCallsCount > 0
            }
            var createWithIntCodableHashableReceivedId: Int?
            var createWithIntCodableHashableReceivedInvocations: [Int] = []
            var createWithIntCodableHashableReturnValue: Codable & Hashable!
            var createWithIntCodableHashableClosure: ((Int) -> Codable & Hashable)?
            func create(with id: Int) -> Codable & Hashable {
                createWithIntCodableHashableCallsCount += 1
                createWithIntCodableHashableReceivedId = (id)
                createWithIntCodableHashableReceivedInvocations.append((id))
                if createWithIntCodableHashableClosure != nil {
                    return createWithIntCodableHashableClosure!(id)
                } else {
                    return createWithIntCodableHashableReturnValue
                }
            }
            private var __spyable_processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount: Int = 0
            var processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processItemanyCodableSendableHandleranyCodableSendableVoid")
                    return __spyable_processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount
                }
                set {
                    __spyable_processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount = newValue
                }
            }
            var processItemanyCodableSendableHandleranyCodableSendableVoidCalled: Bool {
                return processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount > 0
            }
            var processItemanyCodableSendableHandleranyCodableSendableVoidClosure: ((any Codable & Sendable, (any Codable & Sendable) -> Void) -> Void)?
            func process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> Void) {
                __spyableLedger?.record(self, "processItemanyCodableSendableHandleranyCodableSendableVoid", "ProtocolCompositionsProtocolSpy.process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> Void)")
                __spyable_processItemanyCodableSendableHandleranyCodableSendableVoidCallsCount += 1
                processItemanyCodableSendableHandleranyCodableSendableVoidClosure?(item, handler)
            }
            private var __spyable_processItemanyCodableSendableHandleranyCodableSendableStringCallsCount: Int = 0
            var processItemanyCodableSendableHandleranyCodableSendableStringCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processItemanyCodableSendableHandleranyCodableSendableString")
                    return __spyable_processItemanyCodableSendableHandleranyCodableSendableStringCallsCount
                }
                set {
                    __spyable_processItemanyCodableSendableHandleranyCodableSendableStringCallsCount = newValue
                }
            }
            var processItemanyCodableSendableHandleranyCodableSendableStringCalled: Bool {
                return processItemanyCodableSendableHandleranyCodableSendableStringCallsCount > 0
            }
            var processItemanyCodableSendableHandleranyCodableSendableStringClosure: ((any Codable & Sendable, (any Codable & Sendable) -> String) -> Void)?
            func process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> String) {
                __spyableLedger?.record(self, "processItemanyCodableSendableHandleranyCodableSendableString", "ProtocolCompositionsProtocolSpy.process(item: any Codable & Sendable, handler: (any Codable & Sendable) -> String)")
                __spyable_processItemanyCodableSendableHandleranyCodableSendableStringCallsCount += 1
                processItemanyCodableSendableHandleranyCodableSendableStringClosure?(item, handler)
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithAssociatedTypes() {
    let protocolDeclaration = """
      protocol AssociatedTypesProtocol {
        associatedtype Item
        associatedtype Container: Collection
        
        func process(item: Item)
        func process(item: Item) -> Item
        func process(item: Item) -> String
        func process(items: [Item])
        func process(items: [Item]) -> [Item]
        func transform(container: Container)
        func transform(container: Container) -> Container
        func transform(container: Container) -> Int
        func handle(item: Self)
        func handle(item: Self) -> Self
        func handle(item: Self) -> Bool
        func compare(first: Item, second: Item) -> Bool
        func compare(first: Item, second: Item) -> Item
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class AssociatedTypesProtocolSpy<Item, Container: Collection>: AssociatedTypesProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_processItemItemCallsCount: Int = 0
            var processItemItemCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processItemItem")
                    return __spyable_processItemItemCallsCount
                }
                set {
                    __spyable_processItemItemCallsCount = newValue
                }
            }
            var processItemItemCalled: Bool {
                return processItemItemCallsCount > 0
            }
            private var __spyable_processItemItemReceivedItem: Item?
            var processItemItemReceivedItem: Item? {
                get {
                    __spyableLedger?.markVerified(self, "processItemItem")
                    return __spyable_processItemItemReceivedItem
                }
                set {
                    __spyable_processItemItemReceivedItem = newValue
                }
            }
            private var __spyable_processItemItemReceivedInvocations: [Item] = []
            var processItemItemReceivedInvocations: [Item] {
                get {
                    __spyableLedger?.markVerified(self, "processItemItem")
                    return __spyable_processItemItemReceivedInvocations
                }
                set {
                    __spyable_processItemItemReceivedInvocations = newValue
                }
            }
            var processItemItemClosure: ((Item) -> Void)?

            func process(item: Item) {
                __spyableLedger?.record(self, "processItemItem", "AssociatedTypesProtocolSpy.process(item: Item)")
                __spyable_processItemItemCallsCount += 1
                __spyable_processItemItemReceivedItem = (item)
                __spyable_processItemItemReceivedInvocations.append((item))
                processItemItemClosure?(item)
            }
            var processItemItemItemCallsCount = 0
            var processItemItemItemCalled: Bool {
                return processItemItemItemCallsCount > 0
            }
            var processItemItemItemReceivedItem: Item?
            var processItemItemItemReceivedInvocations: [Item] = []
            var processItemItemItemReturnValue: Item!
            var processItemItemItemClosure: ((Item) -> Item)?
            func process(item: Item) -> Item {
                processItemItemItemCallsCount += 1
                processItemItemItemReceivedItem = (item)
                processItemItemItemReceivedInvocations.append((item))
                if processItemItemItemClosure != nil {
                    return processItemItemItemClosure!(item)
                } else {
                    return processItemItemItemReturnValue
                }
            }
            var processItemItemStringCallsCount = 0
            var processItemItemStringCalled: Bool {
                return processItemItemStringCallsCount > 0
            }
            var processItemItemStringReceivedItem: Item?
            var processItemItemStringReceivedInvocations: [Item] = []
            var processItemItemStringReturnValue: String!
            var processItemItemStringClosure: ((Item) -> String)?
            func process(item: Item) -> String {
                processItemItemStringCallsCount += 1
                processItemItemStringReceivedItem = (item)
                processItemItemStringReceivedInvocations.append((item))
                if processItemItemStringClosure != nil {
                    return processItemItemStringClosure!(item)
                } else {
                    return processItemItemStringReturnValue
                }
            }
            private var __spyable_processItemsArrayItemCallsCount: Int = 0
            var processItemsArrayItemCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processItemsArrayItem")
                    return __spyable_processItemsArrayItemCallsCount
                }
                set {
                    __spyable_processItemsArrayItemCallsCount = newValue
                }
            }
            var processItemsArrayItemCalled: Bool {
                return processItemsArrayItemCallsCount > 0
            }
            private var __spyable_processItemsArrayItemReceivedItems: [Item]?
            var processItemsArrayItemReceivedItems: [Item]? {
                get {
                    __spyableLedger?.markVerified(self, "processItemsArrayItem")
                    return __spyable_processItemsArrayItemReceivedItems
                }
                set {
                    __spyable_processItemsArrayItemReceivedItems = newValue
                }
            }
            private var __spyable_processItemsArrayItemReceivedInvocations: [[Item]] = []
            var processItemsArrayItemReceivedInvocations: [[Item]] {
                get {
                    __spyableLedger?.markVerified(self, "processItemsArrayItem")
                    return __spyable_processItemsArrayItemReceivedInvocations
                }
                set {
                    __spyable_processItemsArrayItemReceivedInvocations = newValue
                }
            }
            var processItemsArrayItemClosure: (([Item]) -> Void)?
            func process(items: [Item]) {
                __spyableLedger?.record(self, "processItemsArrayItem", "AssociatedTypesProtocolSpy.process(items: [Item])")
                __spyable_processItemsArrayItemCallsCount += 1
                __spyable_processItemsArrayItemReceivedItems = (items)
                __spyable_processItemsArrayItemReceivedInvocations.append((items))
                processItemsArrayItemClosure?(items)
            }
            var processItemsArrayItemArrayItemCallsCount = 0
            var processItemsArrayItemArrayItemCalled: Bool {
                return processItemsArrayItemArrayItemCallsCount > 0
            }
            var processItemsArrayItemArrayItemReceivedItems: [Item]?
            var processItemsArrayItemArrayItemReceivedInvocations: [[Item]] = []
            var processItemsArrayItemArrayItemReturnValue: [Item]!
            var processItemsArrayItemArrayItemClosure: (([Item]) -> [Item])?
            func process(items: [Item]) -> [Item] {
                processItemsArrayItemArrayItemCallsCount += 1
                processItemsArrayItemArrayItemReceivedItems = (items)
                processItemsArrayItemArrayItemReceivedInvocations.append((items))
                if processItemsArrayItemArrayItemClosure != nil {
                    return processItemsArrayItemArrayItemClosure!(items)
                } else {
                    return processItemsArrayItemArrayItemReturnValue
                }
            }
            private var __spyable_transformContainerContainerCallsCount: Int = 0
            var transformContainerContainerCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "transformContainerContainer")
                    return __spyable_transformContainerContainerCallsCount
                }
                set {
                    __spyable_transformContainerContainerCallsCount = newValue
                }
            }
            var transformContainerContainerCalled: Bool {
                return transformContainerContainerCallsCount > 0
            }
            private var __spyable_transformContainerContainerReceivedContainer: Container?
            var transformContainerContainerReceivedContainer: Container? {
                get {
                    __spyableLedger?.markVerified(self, "transformContainerContainer")
                    return __spyable_transformContainerContainerReceivedContainer
                }
                set {
                    __spyable_transformContainerContainerReceivedContainer = newValue
                }
            }
            private var __spyable_transformContainerContainerReceivedInvocations: [Container] = []
            var transformContainerContainerReceivedInvocations: [Container] {
                get {
                    __spyableLedger?.markVerified(self, "transformContainerContainer")
                    return __spyable_transformContainerContainerReceivedInvocations
                }
                set {
                    __spyable_transformContainerContainerReceivedInvocations = newValue
                }
            }
            var transformContainerContainerClosure: ((Container) -> Void)?
            func transform(container: Container) {
                __spyableLedger?.record(self, "transformContainerContainer", "AssociatedTypesProtocolSpy.transform(container: Container)")
                __spyable_transformContainerContainerCallsCount += 1
                __spyable_transformContainerContainerReceivedContainer = (container)
                __spyable_transformContainerContainerReceivedInvocations.append((container))
                transformContainerContainerClosure?(container)
            }
            var transformContainerContainerContainerCallsCount = 0
            var transformContainerContainerContainerCalled: Bool {
                return transformContainerContainerContainerCallsCount > 0
            }
            var transformContainerContainerContainerReceivedContainer: Container?
            var transformContainerContainerContainerReceivedInvocations: [Container] = []
            var transformContainerContainerContainerReturnValue: Container!
            var transformContainerContainerContainerClosure: ((Container) -> Container)?
            func transform(container: Container) -> Container {
                transformContainerContainerContainerCallsCount += 1
                transformContainerContainerContainerReceivedContainer = (container)
                transformContainerContainerContainerReceivedInvocations.append((container))
                if transformContainerContainerContainerClosure != nil {
                    return transformContainerContainerContainerClosure!(container)
                } else {
                    return transformContainerContainerContainerReturnValue
                }
            }
            var transformContainerContainerIntCallsCount = 0
            var transformContainerContainerIntCalled: Bool {
                return transformContainerContainerIntCallsCount > 0
            }
            var transformContainerContainerIntReceivedContainer: Container?
            var transformContainerContainerIntReceivedInvocations: [Container] = []
            var transformContainerContainerIntReturnValue: Int!
            var transformContainerContainerIntClosure: ((Container) -> Int)?
            func transform(container: Container) -> Int {
                transformContainerContainerIntCallsCount += 1
                transformContainerContainerIntReceivedContainer = (container)
                transformContainerContainerIntReceivedInvocations.append((container))
                if transformContainerContainerIntClosure != nil {
                    return transformContainerContainerIntClosure!(container)
                } else {
                    return transformContainerContainerIntReturnValue
                }
            }
            private var __spyable_handleItemSelfCallsCount: Int = 0
            var handleItemSelfCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "handleItemSelf")
                    return __spyable_handleItemSelfCallsCount
                }
                set {
                    __spyable_handleItemSelfCallsCount = newValue
                }
            }
            var handleItemSelfCalled: Bool {
                return handleItemSelfCallsCount > 0
            }
            private var __spyable_handleItemSelfReceivedItem: Self?
            var handleItemSelfReceivedItem: Self? {
                get {
                    __spyableLedger?.markVerified(self, "handleItemSelf")
                    return __spyable_handleItemSelfReceivedItem
                }
                set {
                    __spyable_handleItemSelfReceivedItem = newValue
                }
            }
            private var __spyable_handleItemSelfReceivedInvocations: [Self] = []
            var handleItemSelfReceivedInvocations: [Self] {
                get {
                    __spyableLedger?.markVerified(self, "handleItemSelf")
                    return __spyable_handleItemSelfReceivedInvocations
                }
                set {
                    __spyable_handleItemSelfReceivedInvocations = newValue
                }
            }
            var handleItemSelfClosure: ((Self) -> Void)?
            func handle(item: Self) {
                __spyableLedger?.record(self, "handleItemSelf", "AssociatedTypesProtocolSpy.handle(item: Self)")
                __spyable_handleItemSelfCallsCount += 1
                __spyable_handleItemSelfReceivedItem = (item)
                __spyable_handleItemSelfReceivedInvocations.append((item))
                handleItemSelfClosure?(item)
            }
            var handleItemSelfSelfCallsCount = 0
            var handleItemSelfSelfCalled: Bool {
                return handleItemSelfSelfCallsCount > 0
            }
            var handleItemSelfSelfReceivedItem: Self?
            var handleItemSelfSelfReceivedInvocations: [Self] = []
            var handleItemSelfSelfReturnValue: Self!
            var handleItemSelfSelfClosure: ((Self) -> Self)?
            func handle(item: Self) -> Self {
                handleItemSelfSelfCallsCount += 1
                handleItemSelfSelfReceivedItem = (item)
                handleItemSelfSelfReceivedInvocations.append((item))
                if handleItemSelfSelfClosure != nil {
                    return handleItemSelfSelfClosure!(item)
                } else {
                    return handleItemSelfSelfReturnValue
                }
            }
            var handleItemSelfBoolCallsCount = 0
            var handleItemSelfBoolCalled: Bool {
                return handleItemSelfBoolCallsCount > 0
            }
            var handleItemSelfBoolReceivedItem: Self?
            var handleItemSelfBoolReceivedInvocations: [Self] = []
            var handleItemSelfBoolReturnValue: Bool!
            var handleItemSelfBoolClosure: ((Self) -> Bool)?
            func handle(item: Self) -> Bool {
                handleItemSelfBoolCallsCount += 1
                handleItemSelfBoolReceivedItem = (item)
                handleItemSelfBoolReceivedInvocations.append((item))
                if handleItemSelfBoolClosure != nil {
                    return handleItemSelfBoolClosure!(item)
                } else {
                    return handleItemSelfBoolReturnValue
                }
            }
            var compareFirstItemSecondItemBoolCallsCount = 0
            var compareFirstItemSecondItemBoolCalled: Bool {
                return compareFirstItemSecondItemBoolCallsCount > 0
            }
            var compareFirstItemSecondItemBoolReceivedArguments: (first: Item, second: Item)?
            var compareFirstItemSecondItemBoolReceivedInvocations: [(first: Item, second: Item)] = []
            var compareFirstItemSecondItemBoolReturnValue: Bool!
            var compareFirstItemSecondItemBoolClosure: ((Item, Item) -> Bool)?
            func compare(first: Item, second: Item) -> Bool {
                compareFirstItemSecondItemBoolCallsCount += 1
                compareFirstItemSecondItemBoolReceivedArguments = (first, second)
                compareFirstItemSecondItemBoolReceivedInvocations.append((first, second))
                if compareFirstItemSecondItemBoolClosure != nil {
                    return compareFirstItemSecondItemBoolClosure!(first, second)
                } else {
                    return compareFirstItemSecondItemBoolReturnValue
                }
            }
            var compareFirstItemSecondItemItemCallsCount = 0
            var compareFirstItemSecondItemItemCalled: Bool {
                return compareFirstItemSecondItemItemCallsCount > 0
            }
            var compareFirstItemSecondItemItemReceivedArguments: (first: Item, second: Item)?
            var compareFirstItemSecondItemItemReceivedInvocations: [(first: Item, second: Item)] = []
            var compareFirstItemSecondItemItemReturnValue: Item!
            var compareFirstItemSecondItemItemClosure: ((Item, Item) -> Item)?
            func compare(first: Item, second: Item) -> Item {
                compareFirstItemSecondItemItemCallsCount += 1
                compareFirstItemSecondItemItemReceivedArguments = (first, second)
                compareFirstItemSecondItemItemReceivedInvocations.append((first, second))
                if compareFirstItemSecondItemItemClosure != nil {
                    return compareFirstItemSecondItemItemClosure!(first, second)
                } else {
                    return compareFirstItemSecondItemItemReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithFunctionAttributes() {
    let protocolDeclaration = """
      protocol FunctionAttributesProtocol {
        // @escaping vs non-escaping closures
        func process(handler: () -> Void)
        func process(handler: @escaping () -> Void)
        func process(handler: @escaping () -> Void) -> String
        
        // @Sendable closures  
        func handle(action: () -> Void)
        func handle(action: @Sendable () -> Void)
        
        // @autoclosure parameters
        func evaluate(_ expression: String)
        func evaluate(_ expression: @autoclosure () -> String)
        
        // Mixed scenarios with closures and @escaping/@Sendable
        func transform(converter: (String) -> Int)
        func transform(converter: @escaping (String) -> Int)
        func transform(converter: @Sendable (String) -> Int)
      }
      """

    // Just test that it compiles without syntax errors - the exact output format may vary
    // but we want to ensure function attributes are properly handled in polymorphic scenarios
    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class FunctionAttributesProtocolSpy: FunctionAttributesProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_processHandlerVoidCallsCount: Int = 0
            var processHandlerVoidCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processHandlerVoid")
                    return __spyable_processHandlerVoidCallsCount
                }
                set {
                    __spyable_processHandlerVoidCallsCount = newValue
                }
            }
            var processHandlerVoidCalled: Bool {
                return processHandlerVoidCallsCount > 0
            }
            var processHandlerVoidClosure: ((() -> Void) -> Void)?
            // @escaping vs non-escaping closures
            func process(handler: () -> Void) {
                __spyableLedger?.record(self, "processHandlerVoid", "FunctionAttributesProtocolSpy.process(handler: () -> Void)")
                __spyable_processHandlerVoidCallsCount += 1
                processHandlerVoidClosure?(handler)
            }
            private var __spyable_processHandlerescapingVoidCallsCount: Int = 0
            var processHandlerescapingVoidCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processHandlerescapingVoid")
                    return __spyable_processHandlerescapingVoidCallsCount
                }
                set {
                    __spyable_processHandlerescapingVoidCallsCount = newValue
                }
            }
            var processHandlerescapingVoidCalled: Bool {
                return processHandlerescapingVoidCallsCount > 0
            }
            private var __spyable_processHandlerescapingVoidReceivedHandler: (() -> Void)?
            var processHandlerescapingVoidReceivedHandler: (() -> Void)? {
                get {
                    __spyableLedger?.markVerified(self, "processHandlerescapingVoid")
                    return __spyable_processHandlerescapingVoidReceivedHandler
                }
                set {
                    __spyable_processHandlerescapingVoidReceivedHandler = newValue
                }
            }
            private var __spyable_processHandlerescapingVoidReceivedInvocations: [() -> Void] = []
            var processHandlerescapingVoidReceivedInvocations: [() -> Void] {
                get {
                    __spyableLedger?.markVerified(self, "processHandlerescapingVoid")
                    return __spyable_processHandlerescapingVoidReceivedInvocations
                }
                set {
                    __spyable_processHandlerescapingVoidReceivedInvocations = newValue
                }
            }
            var processHandlerescapingVoidClosure: ((@escaping () -> Void) -> Void)?
            func process(handler: @escaping () -> Void) {
                __spyableLedger?.record(self, "processHandlerescapingVoid", "FunctionAttributesProtocolSpy.process(handler: @escaping () -> Void)")
                __spyable_processHandlerescapingVoidCallsCount += 1
                __spyable_processHandlerescapingVoidReceivedHandler = (handler)
                __spyable_processHandlerescapingVoidReceivedInvocations.append((handler))
                processHandlerescapingVoidClosure?(handler)
            }
            var processHandlerescapingVoidStringCallsCount = 0
            var processHandlerescapingVoidStringCalled: Bool {
                return processHandlerescapingVoidStringCallsCount > 0
            }
            var processHandlerescapingVoidStringReceivedHandler: (() -> Void)?
            var processHandlerescapingVoidStringReceivedInvocations: [() -> Void] = []
            var processHandlerescapingVoidStringReturnValue: String!
            var processHandlerescapingVoidStringClosure: ((@escaping () -> Void) -> String)?
            func process(handler: @escaping () -> Void) -> String {
                processHandlerescapingVoidStringCallsCount += 1
                processHandlerescapingVoidStringReceivedHandler = (handler)
                processHandlerescapingVoidStringReceivedInvocations.append((handler))
                if processHandlerescapingVoidStringClosure != nil {
                    return processHandlerescapingVoidStringClosure!(handler)
                } else {
                    return processHandlerescapingVoidStringReturnValue
                }
            }
            private var __spyable_handleActionVoidCallsCount: Int = 0
            var handleActionVoidCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "handleActionVoid")
                    return __spyable_handleActionVoidCallsCount
                }
                set {
                    __spyable_handleActionVoidCallsCount = newValue
                }
            }
            var handleActionVoidCalled: Bool {
                return handleActionVoidCallsCount > 0
            }
            var handleActionVoidClosure: ((() -> Void) -> Void)?

            // @Sendable closures  
            func handle(action: () -> Void) {
                __spyableLedger?.record(self, "handleActionVoid", "FunctionAttributesProtocolSpy.handle(action: () -> Void)")
                __spyable_handleActionVoidCallsCount += 1
                handleActionVoidClosure?(action)
            }
            private var __spyable_handleActionSendableVoidCallsCount: Int = 0
            var handleActionSendableVoidCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "handleActionSendableVoid")
                    return __spyable_handleActionSendableVoidCallsCount
                }
                set {
                    __spyable_handleActionSendableVoidCallsCount = newValue
                }
            }
            var handleActionSendableVoidCalled: Bool {
                return handleActionSendableVoidCallsCount > 0
            }
            var handleActionSendableVoidClosure: ((@Sendable () -> Void) -> Void)?
            func handle(action: @Sendable () -> Void) {
                __spyableLedger?.record(self, "handleActionSendableVoid", "FunctionAttributesProtocolSpy.handle(action: @Sendable () -> Void)")
                __spyable_handleActionSendableVoidCallsCount += 1
                handleActionSendableVoidClosure?(action)
            }
            private var __spyable_evaluateCallsCount: Int = 0
            var evaluateCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "evaluate")
                    return __spyable_evaluateCallsCount
                }
                set {
                    __spyable_evaluateCallsCount = newValue
                }
            }
            var evaluateCalled: Bool {
                return evaluateCallsCount > 0
            }
            private var __spyable_evaluateReceivedExpression: String?
            var evaluateReceivedExpression: String? {
                get {
                    __spyableLedger?.markVerified(self, "evaluate")
                    return __spyable_evaluateReceivedExpression
                }
                set {
                    __spyable_evaluateReceivedExpression = newValue
                }
            }
            private var __spyable_evaluateReceivedInvocations: [String] = []
            var evaluateReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "evaluate")
                    return __spyable_evaluateReceivedInvocations
                }
                set {
                    __spyable_evaluateReceivedInvocations = newValue
                }
            }
            var evaluateClosure: ((String) -> Void)?

            // @autoclosure parameters
            func evaluate(_ expression: String) {
                __spyableLedger?.record(self, "evaluate", "FunctionAttributesProtocolSpy.evaluate(_: String)")
                __spyable_evaluateCallsCount += 1
                __spyable_evaluateReceivedExpression = (expression)
                __spyable_evaluateReceivedInvocations.append((expression))
                evaluateClosure?(expression)
            }
            private var __spyable_evaluateCallsCount: Int = 0
            var evaluateCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "evaluate")
                    return __spyable_evaluateCallsCount
                }
                set {
                    __spyable_evaluateCallsCount = newValue
                }
            }
            var evaluateCalled: Bool {
                return evaluateCallsCount > 0
            }
            var evaluateClosure: ((@autoclosure () -> String) -> Void)?
            func evaluate(_ expression: @autoclosure () -> String) {
                __spyableLedger?.record(self, "evaluate", "FunctionAttributesProtocolSpy.evaluate(_: @autoclosure () -> String)")
                __spyable_evaluateCallsCount += 1
                evaluateClosure?(expression())
            }
            private var __spyable_transformConverterStringIntCallsCount: Int = 0
            var transformConverterStringIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "transformConverterStringInt")
                    return __spyable_transformConverterStringIntCallsCount
                }
                set {
                    __spyable_transformConverterStringIntCallsCount = newValue
                }
            }
            var transformConverterStringIntCalled: Bool {
                return transformConverterStringIntCallsCount > 0
            }
            var transformConverterStringIntClosure: (((String) -> Int) -> Void)?

            // Mixed scenarios with closures and @escaping/@Sendable
            func transform(converter: (String) -> Int) {
                __spyableLedger?.record(self, "transformConverterStringInt", "FunctionAttributesProtocolSpy.transform(converter: (String) -> Int)")
                __spyable_transformConverterStringIntCallsCount += 1
                transformConverterStringIntClosure?(converter)
            }
            private var __spyable_transformConverterescapingStringIntCallsCount: Int = 0
            var transformConverterescapingStringIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "transformConverterescapingStringInt")
                    return __spyable_transformConverterescapingStringIntCallsCount
                }
                set {
                    __spyable_transformConverterescapingStringIntCallsCount = newValue
                }
            }
            var transformConverterescapingStringIntCalled: Bool {
                return transformConverterescapingStringIntCallsCount > 0
            }
            private var __spyable_transformConverterescapingStringIntReceivedConverter: ((String) -> Int)?
            var transformConverterescapingStringIntReceivedConverter: ((String) -> Int)? {
                get {
                    __spyableLedger?.markVerified(self, "transformConverterescapingStringInt")
                    return __spyable_transformConverterescapingStringIntReceivedConverter
                }
                set {
                    __spyable_transformConverterescapingStringIntReceivedConverter = newValue
                }
            }
            private var __spyable_transformConverterescapingStringIntReceivedInvocations: [(String) -> Int] = []
            var transformConverterescapingStringIntReceivedInvocations: [(String) -> Int] {
                get {
                    __spyableLedger?.markVerified(self, "transformConverterescapingStringInt")
                    return __spyable_transformConverterescapingStringIntReceivedInvocations
                }
                set {
                    __spyable_transformConverterescapingStringIntReceivedInvocations = newValue
                }
            }
            var transformConverterescapingStringIntClosure: ((@escaping (String) -> Int) -> Void)?
            func transform(converter: @escaping (String) -> Int) {
                __spyableLedger?.record(self, "transformConverterescapingStringInt", "FunctionAttributesProtocolSpy.transform(converter: @escaping (String) -> Int)")
                __spyable_transformConverterescapingStringIntCallsCount += 1
                __spyable_transformConverterescapingStringIntReceivedConverter = (converter)
                __spyable_transformConverterescapingStringIntReceivedInvocations.append((converter))
                transformConverterescapingStringIntClosure?(converter)
            }
            private var __spyable_transformConverterSendableStringIntCallsCount: Int = 0
            var transformConverterSendableStringIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "transformConverterSendableStringInt")
                    return __spyable_transformConverterSendableStringIntCallsCount
                }
                set {
                    __spyable_transformConverterSendableStringIntCallsCount = newValue
                }
            }
            var transformConverterSendableStringIntCalled: Bool {
                return transformConverterSendableStringIntCallsCount > 0
            }
            var transformConverterSendableStringIntClosure: ((@Sendable (String) -> Int) -> Void)?
            func transform(converter: @Sendable (String) -> Int) {
                __spyableLedger?.record(self, "transformConverterSendableStringInt", "FunctionAttributesProtocolSpy.transform(converter: @Sendable (String) -> Int)")
                __spyable_transformConverterSendableStringIntCallsCount += 1
                transformConverterSendableStringIntClosure?(converter)
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithAsyncThrowingCombinations() {
    let protocolDeclaration = """
      protocol AsyncThrowingPolymorphismProtocol {
        // Valid polymorphic functions with different parameter types and async/throwing combinations
        func fetch(immediate: Bool)
        func fetch(from url: String) async
        func fetch(resource id: Int) throws 
        func fetch(withTimeout timeout: Double) async throws
        
        // Functions with return types and different parameter signatures
        func load() -> String
        func load(async priority: Int) async -> String
        func load(throwing validation: Bool) throws -> String
        func load(timeout: TimeInterval) async throws -> String
        
        // Functions with different parameter count and async/throwing combinations
        func process(id: Int)
        func process(id: Int, priority: Int) async
        func process(id: Int, with config: String) throws
        func process(id: Int, priority: Int, timeout: Double) async throws
        func process(id: Int) -> Bool
        func process(id: Int, flag: Bool) async -> Bool
        func process(id: Int, options: [String]) throws -> Bool
        func process(id: Int, flag: Bool, timeout: TimeInterval) async throws -> Bool
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """
        \(protocolDeclaration)

        #if DEBUG
        class AsyncThrowingPolymorphismProtocolSpy: AsyncThrowingPolymorphismProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_fetchImmediateCallsCount: Int = 0
            var fetchImmediateCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchImmediate")
                    return __spyable_fetchImmediateCallsCount
                }
                set {
                    __spyable_fetchImmediateCallsCount = newValue
                }
            }
            var fetchImmediateCalled: Bool {
                return fetchImmediateCallsCount > 0
            }
            private var __spyable_fetchImmediateReceivedImmediate: Bool?
            var fetchImmediateReceivedImmediate: Bool? {
                get {
                    __spyableLedger?.markVerified(self, "fetchImmediate")
                    return __spyable_fetchImmediateReceivedImmediate
                }
                set {
                    __spyable_fetchImmediateReceivedImmediate = newValue
                }
            }
            private var __spyable_fetchImmediateReceivedInvocations: [Bool] = []
            var fetchImmediateReceivedInvocations: [Bool] {
                get {
                    __spyableLedger?.markVerified(self, "fetchImmediate")
                    return __spyable_fetchImmediateReceivedInvocations
                }
                set {
                    __spyable_fetchImmediateReceivedInvocations = newValue
                }
            }
            var fetchImmediateClosure: ((Bool) -> Void)?
            // Valid polymorphic functions with different parameter types and async/throwing combinations
            func fetch(immediate: Bool) {
                __spyableLedger?.record(self, "fetchImmediate", "AsyncThrowingPolymorphismProtocolSpy.fetch(immediate:)")
                __spyable_fetchImmediateCallsCount += 1
                __spyable_fetchImmediateReceivedImmediate = (immediate)
                __spyable_fetchImmediateReceivedInvocations.append((immediate))
                fetchImmediateClosure?(immediate)
            }
            private var __spyable_fetchFromCallsCount: Int = 0
            var fetchFromCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchFrom")
                    return __spyable_fetchFromCallsCount
                }
                set {
                    __spyable_fetchFromCallsCount = newValue
                }
            }
            var fetchFromCalled: Bool {
                return fetchFromCallsCount > 0
            }
            private var __spyable_fetchFromReceivedUrl: String?
            var fetchFromReceivedUrl: String? {
                get {
                    __spyableLedger?.markVerified(self, "fetchFrom")
                    return __spyable_fetchFromReceivedUrl
                }
                set {
                    __spyable_fetchFromReceivedUrl = newValue
                }
            }
            private var __spyable_fetchFromReceivedInvocations: [String] = []
            var fetchFromReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "fetchFrom")
                    return __spyable_fetchFromReceivedInvocations
                }
                set {
                    __spyable_fetchFromReceivedInvocations = newValue
                }
            }
            var fetchFromClosure: ((String) async -> Void)?
            func fetch(from url: String) async {
                __spyableLedger?.record(self, "fetchFrom", "AsyncThrowingPolymorphismProtocolSpy.fetch(from:)")
                __spyable_fetchFromCallsCount += 1
                __spyable_fetchFromReceivedUrl = (url)
                __spyable_fetchFromReceivedInvocations.append((url))
                await fetchFromClosure?(url)
            }
            private var __spyable_fetchResourceCallsCount: Int = 0
            var fetchResourceCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchResource")
                    return __spyable_fetchResourceCallsCount
                }
                set {
                    __spyable_fetchResourceCallsCount = newValue
                }
            }
            var fetchResourceCalled: Bool {
                return fetchResourceCallsCount > 0
            }
            private var __spyable_fetchResourceReceivedId: Int?
            var fetchResourceReceivedId: Int? {
                get {
                    __spyableLedger?.markVerified(self, "fetchResource")
                    return __spyable_fetchResourceReceivedId
                }
                set {
                    __spyable_fetchResourceReceivedId = newValue
                }
            }
            private var __spyable_fetchResourceReceivedInvocations: [Int] = []
            var fetchResourceReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "fetchResource")
                    return __spyable_fetchResourceReceivedInvocations
                }
                set {
                    __spyable_fetchResourceReceivedInvocations = newValue
                }
            }
            var fetchResourceThrowableError: (any Error)?
            var fetchResourceClosure: ((Int) throws -> Void)?
            func fetch(resource id: Int) throws {
                __spyableLedger?.record(self, "fetchResource", "AsyncThrowingPolymorphismProtocolSpy.fetch(resource:)")
                __spyable_fetchResourceCallsCount += 1
                __spyable_fetchResourceReceivedId = (id)
                __spyable_fetchResourceReceivedInvocations.append((id))
                if let fetchResourceThrowableError {
                    throw fetchResourceThrowableError
                }
                try fetchResourceClosure?(id)
            }
            private var __spyable_fetchWithTimeoutCallsCount: Int = 0
            var fetchWithTimeoutCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "fetchWithTimeout")
                    return __spyable_fetchWithTimeoutCallsCount
                }
                set {
                    __spyable_fetchWithTimeoutCallsCount = newValue
                }
            }
            var fetchWithTimeoutCalled: Bool {
                return fetchWithTimeoutCallsCount > 0
            }
            private var __spyable_fetchWithTimeoutReceivedTimeout: Double?
            var fetchWithTimeoutReceivedTimeout: Double? {
                get {
                    __spyableLedger?.markVerified(self, "fetchWithTimeout")
                    return __spyable_fetchWithTimeoutReceivedTimeout
                }
                set {
                    __spyable_fetchWithTimeoutReceivedTimeout = newValue
                }
            }
            private var __spyable_fetchWithTimeoutReceivedInvocations: [Double] = []
            var fetchWithTimeoutReceivedInvocations: [Double] {
                get {
                    __spyableLedger?.markVerified(self, "fetchWithTimeout")
                    return __spyable_fetchWithTimeoutReceivedInvocations
                }
                set {
                    __spyable_fetchWithTimeoutReceivedInvocations = newValue
                }
            }
            var fetchWithTimeoutThrowableError: (any Error)?
            var fetchWithTimeoutClosure: ((Double) async throws -> Void)?
            func fetch(withTimeout timeout: Double) async throws {
                __spyableLedger?.record(self, "fetchWithTimeout", "AsyncThrowingPolymorphismProtocolSpy.fetch(withTimeout:)")
                __spyable_fetchWithTimeoutCallsCount += 1
                __spyable_fetchWithTimeoutReceivedTimeout = (timeout)
                __spyable_fetchWithTimeoutReceivedInvocations.append((timeout))
                if let fetchWithTimeoutThrowableError {
                    throw fetchWithTimeoutThrowableError
                }
                try await fetchWithTimeoutClosure?(timeout)
            }
            var loadCallsCount = 0
            var loadCalled: Bool {
                return loadCallsCount > 0
            }
            var loadReturnValue: String!
            var loadClosure: (() -> String)?

            // Functions with return types and different parameter signatures
            func load() -> String {
                loadCallsCount += 1
                if loadClosure != nil {
                    return loadClosure!()
                } else {
                    return loadReturnValue
                }
            }
            var loadAsyncCallsCount = 0
            var loadAsyncCalled: Bool {
                return loadAsyncCallsCount > 0
            }
            var loadAsyncReceivedPriority: Int?
            var loadAsyncReceivedInvocations: [Int] = []
            var loadAsyncReturnValue: String!
            var loadAsyncClosure: ((Int) async -> String)?
            func load(async priority: Int) async -> String {
                loadAsyncCallsCount += 1
                loadAsyncReceivedPriority = (priority)
                loadAsyncReceivedInvocations.append((priority))
                if loadAsyncClosure != nil {
                    return await loadAsyncClosure!(priority)
                } else {
                    return loadAsyncReturnValue
                }
            }
            var loadThrowingCallsCount = 0
            var loadThrowingCalled: Bool {
                return loadThrowingCallsCount > 0
            }
            var loadThrowingReceivedValidation: Bool?
            var loadThrowingReceivedInvocations: [Bool] = []
            var loadThrowingThrowableError: (any Error)?
            var loadThrowingReturnValue: String!
            var loadThrowingClosure: ((Bool) throws -> String)?
            func load(throwing validation: Bool) throws -> String {
                loadThrowingCallsCount += 1
                loadThrowingReceivedValidation = (validation)
                loadThrowingReceivedInvocations.append((validation))
                if let loadThrowingThrowableError {
                    throw loadThrowingThrowableError
                }
                if loadThrowingClosure != nil {
                    return try loadThrowingClosure!(validation)
                } else {
                    return loadThrowingReturnValue
                }
            }
            var loadTimeoutCallsCount = 0
            var loadTimeoutCalled: Bool {
                return loadTimeoutCallsCount > 0
            }
            var loadTimeoutReceivedTimeout: TimeInterval?
            var loadTimeoutReceivedInvocations: [TimeInterval] = []
            var loadTimeoutThrowableError: (any Error)?
            var loadTimeoutReturnValue: String!
            var loadTimeoutClosure: ((TimeInterval) async throws -> String)?
            func load(timeout: TimeInterval) async throws -> String {
                loadTimeoutCallsCount += 1
                loadTimeoutReceivedTimeout = (timeout)
                loadTimeoutReceivedInvocations.append((timeout))
                if let loadTimeoutThrowableError {
                    throw loadTimeoutThrowableError
                }
                if loadTimeoutClosure != nil {
                    return try await loadTimeoutClosure!(timeout)
                } else {
                    return loadTimeoutReturnValue
                }
            }
            private var __spyable_processIdIntCallsCount: Int = 0
            var processIdIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processIdInt")
                    return __spyable_processIdIntCallsCount
                }
                set {
                    __spyable_processIdIntCallsCount = newValue
                }
            }
            var processIdIntCalled: Bool {
                return processIdIntCallsCount > 0
            }
            private var __spyable_processIdIntReceivedId: Int?
            var processIdIntReceivedId: Int? {
                get {
                    __spyableLedger?.markVerified(self, "processIdInt")
                    return __spyable_processIdIntReceivedId
                }
                set {
                    __spyable_processIdIntReceivedId = newValue
                }
            }
            private var __spyable_processIdIntReceivedInvocations: [Int] = []
            var processIdIntReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "processIdInt")
                    return __spyable_processIdIntReceivedInvocations
                }
                set {
                    __spyable_processIdIntReceivedInvocations = newValue
                }
            }
            var processIdIntClosure: ((Int) -> Void)?

            // Functions with different parameter count and async/throwing combinations
            func process(id: Int) {
                __spyableLedger?.record(self, "processIdInt", "AsyncThrowingPolymorphismProtocolSpy.process(id: Int)")
                __spyable_processIdIntCallsCount += 1
                __spyable_processIdIntReceivedId = (id)
                __spyable_processIdIntReceivedInvocations.append((id))
                processIdIntClosure?(id)
            }
            private var __spyable_processIdPriorityCallsCount: Int = 0
            var processIdPriorityCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriority")
                    return __spyable_processIdPriorityCallsCount
                }
                set {
                    __spyable_processIdPriorityCallsCount = newValue
                }
            }
            var processIdPriorityCalled: Bool {
                return processIdPriorityCallsCount > 0
            }
            private var __spyable_processIdPriorityReceivedArguments: (id: Int, priority: Int)?
            var processIdPriorityReceivedArguments: (id: Int, priority: Int)? {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriority")
                    return __spyable_processIdPriorityReceivedArguments
                }
                set {
                    __spyable_processIdPriorityReceivedArguments = newValue
                }
            }
            private var __spyable_processIdPriorityReceivedInvocations: [(id: Int, priority: Int)] = []
            var processIdPriorityReceivedInvocations: [(id: Int, priority: Int)] {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriority")
                    return __spyable_processIdPriorityReceivedInvocations
                }
                set {
                    __spyable_processIdPriorityReceivedInvocations = newValue
                }
            }
            var processIdPriorityClosure: ((Int, Int) async -> Void)?
            func process(id: Int, priority: Int) async {
                __spyableLedger?.record(self, "processIdPriority", "AsyncThrowingPolymorphismProtocolSpy.process(id:priority:)")
                __spyable_processIdPriorityCallsCount += 1
                __spyable_processIdPriorityReceivedArguments = (id, priority)
                __spyable_processIdPriorityReceivedInvocations.append((id, priority))
                await processIdPriorityClosure?(id, priority)
            }
            private var __spyable_processIdWithCallsCount: Int = 0
            var processIdWithCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processIdWith")
                    return __spyable_processIdWithCallsCount
                }
                set {
                    __spyable_processIdWithCallsCount = newValue
                }
            }
            var processIdWithCalled: Bool {
                return processIdWithCallsCount > 0
            }
            private var __spyable_processIdWithReceivedArguments: (id: Int, config: String)?
            var processIdWithReceivedArguments: (id: Int, config: String)? {
                get {
                    __spyableLedger?.markVerified(self, "processIdWith")
                    return __spyable_processIdWithReceivedArguments
                }
                set {
                    __spyable_processIdWithReceivedArguments = newValue
                }
            }
            private var __spyable_processIdWithReceivedInvocations: [(id: Int, config: String)] = []
            var processIdWithReceivedInvocations: [(id: Int, config: String)] {
                get {
                    __spyableLedger?.markVerified(self, "processIdWith")
                    return __spyable_processIdWithReceivedInvocations
                }
                set {
                    __spyable_processIdWithReceivedInvocations = newValue
                }
            }
            var processIdWithThrowableError: (any Error)?
            var processIdWithClosure: ((Int, String) throws -> Void)?
            func process(id: Int, with config: String) throws {
                __spyableLedger?.record(self, "processIdWith", "AsyncThrowingPolymorphismProtocolSpy.process(id:with:)")
                __spyable_processIdWithCallsCount += 1
                __spyable_processIdWithReceivedArguments = (id, config)
                __spyable_processIdWithReceivedInvocations.append((id, config))
                if let processIdWithThrowableError {
                    throw processIdWithThrowableError
                }
                try processIdWithClosure?(id, config)
            }
            private var __spyable_processIdPriorityTimeoutCallsCount: Int = 0
            var processIdPriorityTimeoutCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriorityTimeout")
                    return __spyable_processIdPriorityTimeoutCallsCount
                }
                set {
                    __spyable_processIdPriorityTimeoutCallsCount = newValue
                }
            }
            var processIdPriorityTimeoutCalled: Bool {
                return processIdPriorityTimeoutCallsCount > 0
            }
            private var __spyable_processIdPriorityTimeoutReceivedArguments: (id: Int, priority: Int, timeout: Double)?
            var processIdPriorityTimeoutReceivedArguments: (id: Int, priority: Int, timeout: Double)? {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriorityTimeout")
                    return __spyable_processIdPriorityTimeoutReceivedArguments
                }
                set {
                    __spyable_processIdPriorityTimeoutReceivedArguments = newValue
                }
            }
            private var __spyable_processIdPriorityTimeoutReceivedInvocations: [(id: Int, priority: Int, timeout: Double)] = []
            var processIdPriorityTimeoutReceivedInvocations: [(id: Int, priority: Int, timeout: Double)] {
                get {
                    __spyableLedger?.markVerified(self, "processIdPriorityTimeout")
                    return __spyable_processIdPriorityTimeoutReceivedInvocations
                }
                set {
                    __spyable_processIdPriorityTimeoutReceivedInvocations = newValue
                }
            }
            var processIdPriorityTimeoutThrowableError: (any Error)?
            var processIdPriorityTimeoutClosure: ((Int, Int, Double) async throws -> Void)?
            func process(id: Int, priority: Int, timeout: Double) async throws {
                __spyableLedger?.record(self, "processIdPriorityTimeout", "AsyncThrowingPolymorphismProtocolSpy.process(id:priority:timeout:)")
                __spyable_processIdPriorityTimeoutCallsCount += 1
                __spyable_processIdPriorityTimeoutReceivedArguments = (id, priority, timeout)
                __spyable_processIdPriorityTimeoutReceivedInvocations.append((id, priority, timeout))
                if let processIdPriorityTimeoutThrowableError {
                    throw processIdPriorityTimeoutThrowableError
                }
                try await processIdPriorityTimeoutClosure?(id, priority, timeout)
            }
            var processIdIntBoolCallsCount = 0
            var processIdIntBoolCalled: Bool {
                return processIdIntBoolCallsCount > 0
            }
            var processIdIntBoolReceivedId: Int?
            var processIdIntBoolReceivedInvocations: [Int] = []
            var processIdIntBoolReturnValue: Bool!
            var processIdIntBoolClosure: ((Int) -> Bool)?
            func process(id: Int) -> Bool {
                processIdIntBoolCallsCount += 1
                processIdIntBoolReceivedId = (id)
                processIdIntBoolReceivedInvocations.append((id))
                if processIdIntBoolClosure != nil {
                    return processIdIntBoolClosure!(id)
                } else {
                    return processIdIntBoolReturnValue
                }
            }
            var processIdFlagCallsCount = 0
            var processIdFlagCalled: Bool {
                return processIdFlagCallsCount > 0
            }
            var processIdFlagReceivedArguments: (id: Int, flag: Bool)?
            var processIdFlagReceivedInvocations: [(id: Int, flag: Bool)] = []
            var processIdFlagReturnValue: Bool!
            var processIdFlagClosure: ((Int, Bool) async -> Bool)?
            func process(id: Int, flag: Bool) async -> Bool {
                processIdFlagCallsCount += 1
                processIdFlagReceivedArguments = (id, flag)
                processIdFlagReceivedInvocations.append((id, flag))
                if processIdFlagClosure != nil {
                    return await processIdFlagClosure!(id, flag)
                } else {
                    return processIdFlagReturnValue
                }
            }
            var processIdOptionsCallsCount = 0
            var processIdOptionsCalled: Bool {
                return processIdOptionsCallsCount > 0
            }
            var processIdOptionsReceivedArguments: (id: Int, options: [String])?
            var processIdOptionsReceivedInvocations: [(id: Int, options: [String])] = []
            var processIdOptionsThrowableError: (any Error)?
            var processIdOptionsReturnValue: Bool!
            var processIdOptionsClosure: ((Int, [String]) throws -> Bool)?
            func process(id: Int, options: [String]) throws -> Bool {
                processIdOptionsCallsCount += 1
                processIdOptionsReceivedArguments = (id, options)
                processIdOptionsReceivedInvocations.append((id, options))
                if let processIdOptionsThrowableError {
                    throw processIdOptionsThrowableError
                }
                if processIdOptionsClosure != nil {
                    return try processIdOptionsClosure!(id, options)
                } else {
                    return processIdOptionsReturnValue
                }
            }
            var processIdFlagTimeoutCallsCount = 0
            var processIdFlagTimeoutCalled: Bool {
                return processIdFlagTimeoutCallsCount > 0
            }
            var processIdFlagTimeoutReceivedArguments: (id: Int, flag: Bool, timeout: TimeInterval)?
            var processIdFlagTimeoutReceivedInvocations: [(id: Int, flag: Bool, timeout: TimeInterval)] = []
            var processIdFlagTimeoutThrowableError: (any Error)?
            var processIdFlagTimeoutReturnValue: Bool!
            var processIdFlagTimeoutClosure: ((Int, Bool, TimeInterval) async throws -> Bool)?
            func process(id: Int, flag: Bool, timeout: TimeInterval) async throws -> Bool {
                processIdFlagTimeoutCallsCount += 1
                processIdFlagTimeoutReceivedArguments = (id, flag, timeout)
                processIdFlagTimeoutReceivedInvocations.append((id, flag, timeout))
                if let processIdFlagTimeoutThrowableError {
                    throw processIdFlagTimeoutThrowableError
                }
                if processIdFlagTimeoutClosure != nil {
                    return try await processIdFlagTimeoutClosure!(id, flag, timeout)
                } else {
                    return processIdFlagTimeoutReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }

  func testPolymorphismWithInoutParameters() {
    let protocolDeclaration = """
      protocol InoutParametersProtocol {
        func update(value: inout Int)
        func update(value: Int)
        func update(value: inout String)
        func update(value: inout Int, flag: Bool)
        func update(value: Int, flag: Bool)
        func process(data: inout Data) -> Bool
        func process(data: Data) -> Bool
        func process(data: inout Data) -> String
        func swap(first: inout Int, second: inout Int)
        func swap(first: inout String, second: inout String)
        func swap(first: inout Int, second: inout Int, third: inout Int)
        func transform(input: inout String, options: [String: Any]) -> Int
        func transform(input: String, options: [String: Any]) -> Int
        func transform(input: inout String, options: [String: Any]) -> String
        func transform(input: inout String, options: inout [String: Any]) -> String
        func configure(settings: inout [String: Any]) async throws
        func configure(settings: [String: Any]) async throws
        func configure(settings: inout [String: Any]) throws -> Bool
        func configure(settings: [String: Any]) throws -> Bool
      }
      """

    assertMacroExpansion(
      """
      @Spyable
      \(protocolDeclaration)
      """,
      expandedSource: """

        \(protocolDeclaration)

        #if DEBUG
        class InoutParametersProtocolSpy: InoutParametersProtocol, @unchecked Sendable {
            init() {
            }
            private let __spyableLedger: SpyableLedger? = SpyableLedger.current
            private var __spyable_updateValueinoutIntCallsCount: Int = 0
            var updateValueinoutIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutInt")
                    return __spyable_updateValueinoutIntCallsCount
                }
                set {
                    __spyable_updateValueinoutIntCallsCount = newValue
                }
            }
            var updateValueinoutIntCalled: Bool {
                return updateValueinoutIntCallsCount > 0
            }
            private var __spyable_updateValueinoutIntReceivedValue: Int?
            var updateValueinoutIntReceivedValue: Int? {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutInt")
                    return __spyable_updateValueinoutIntReceivedValue
                }
                set {
                    __spyable_updateValueinoutIntReceivedValue = newValue
                }
            }
            private var __spyable_updateValueinoutIntReceivedInvocations: [Int] = []
            var updateValueinoutIntReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutInt")
                    return __spyable_updateValueinoutIntReceivedInvocations
                }
                set {
                    __spyable_updateValueinoutIntReceivedInvocations = newValue
                }
            }
            var updateValueinoutIntClosure: ((inout Int) -> Void)?
            func update(value: inout Int) {
                __spyableLedger?.record(self, "updateValueinoutInt", "InoutParametersProtocolSpy.update(value: inout Int)")
                __spyable_updateValueinoutIntCallsCount += 1
                __spyable_updateValueinoutIntReceivedValue = (value)
                __spyable_updateValueinoutIntReceivedInvocations.append((value))
                updateValueinoutIntClosure?(&value)
            }
            private var __spyable_updateValueIntCallsCount: Int = 0
            var updateValueIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "updateValueInt")
                    return __spyable_updateValueIntCallsCount
                }
                set {
                    __spyable_updateValueIntCallsCount = newValue
                }
            }
            var updateValueIntCalled: Bool {
                return updateValueIntCallsCount > 0
            }
            private var __spyable_updateValueIntReceivedValue: Int?
            var updateValueIntReceivedValue: Int? {
                get {
                    __spyableLedger?.markVerified(self, "updateValueInt")
                    return __spyable_updateValueIntReceivedValue
                }
                set {
                    __spyable_updateValueIntReceivedValue = newValue
                }
            }
            private var __spyable_updateValueIntReceivedInvocations: [Int] = []
            var updateValueIntReceivedInvocations: [Int] {
                get {
                    __spyableLedger?.markVerified(self, "updateValueInt")
                    return __spyable_updateValueIntReceivedInvocations
                }
                set {
                    __spyable_updateValueIntReceivedInvocations = newValue
                }
            }
            var updateValueIntClosure: ((Int) -> Void)?
            func update(value: Int) {
                __spyableLedger?.record(self, "updateValueInt", "InoutParametersProtocolSpy.update(value: Int)")
                __spyable_updateValueIntCallsCount += 1
                __spyable_updateValueIntReceivedValue = (value)
                __spyable_updateValueIntReceivedInvocations.append((value))
                updateValueIntClosure?(value)
            }
            private var __spyable_updateValueinoutStringCallsCount: Int = 0
            var updateValueinoutStringCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutString")
                    return __spyable_updateValueinoutStringCallsCount
                }
                set {
                    __spyable_updateValueinoutStringCallsCount = newValue
                }
            }
            var updateValueinoutStringCalled: Bool {
                return updateValueinoutStringCallsCount > 0
            }
            private var __spyable_updateValueinoutStringReceivedValue: String?
            var updateValueinoutStringReceivedValue: String? {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutString")
                    return __spyable_updateValueinoutStringReceivedValue
                }
                set {
                    __spyable_updateValueinoutStringReceivedValue = newValue
                }
            }
            private var __spyable_updateValueinoutStringReceivedInvocations: [String] = []
            var updateValueinoutStringReceivedInvocations: [String] {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutString")
                    return __spyable_updateValueinoutStringReceivedInvocations
                }
                set {
                    __spyable_updateValueinoutStringReceivedInvocations = newValue
                }
            }
            var updateValueinoutStringClosure: ((inout String) -> Void)?
            func update(value: inout String) {
                __spyableLedger?.record(self, "updateValueinoutString", "InoutParametersProtocolSpy.update(value: inout String)")
                __spyable_updateValueinoutStringCallsCount += 1
                __spyable_updateValueinoutStringReceivedValue = (value)
                __spyable_updateValueinoutStringReceivedInvocations.append((value))
                updateValueinoutStringClosure?(&value)
            }
            private var __spyable_updateValueinoutIntFlagBoolCallsCount: Int = 0
            var updateValueinoutIntFlagBoolCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutIntFlagBool")
                    return __spyable_updateValueinoutIntFlagBoolCallsCount
                }
                set {
                    __spyable_updateValueinoutIntFlagBoolCallsCount = newValue
                }
            }
            var updateValueinoutIntFlagBoolCalled: Bool {
                return updateValueinoutIntFlagBoolCallsCount > 0
            }
            private var __spyable_updateValueinoutIntFlagBoolReceivedArguments: (value: Int, flag: Bool)?
            var updateValueinoutIntFlagBoolReceivedArguments: (value: Int, flag: Bool)? {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutIntFlagBool")
                    return __spyable_updateValueinoutIntFlagBoolReceivedArguments
                }
                set {
                    __spyable_updateValueinoutIntFlagBoolReceivedArguments = newValue
                }
            }
            private var __spyable_updateValueinoutIntFlagBoolReceivedInvocations: [(value: Int, flag: Bool)] = []
            var updateValueinoutIntFlagBoolReceivedInvocations: [(value: Int, flag: Bool)] {
                get {
                    __spyableLedger?.markVerified(self, "updateValueinoutIntFlagBool")
                    return __spyable_updateValueinoutIntFlagBoolReceivedInvocations
                }
                set {
                    __spyable_updateValueinoutIntFlagBoolReceivedInvocations = newValue
                }
            }
            var updateValueinoutIntFlagBoolClosure: ((inout Int, Bool) -> Void)?
            func update(value: inout Int, flag: Bool) {
                __spyableLedger?.record(self, "updateValueinoutIntFlagBool", "InoutParametersProtocolSpy.update(value: inout Int, flag: Bool)")
                __spyable_updateValueinoutIntFlagBoolCallsCount += 1
                __spyable_updateValueinoutIntFlagBoolReceivedArguments = (value, flag)
                __spyable_updateValueinoutIntFlagBoolReceivedInvocations.append((value, flag))
                updateValueinoutIntFlagBoolClosure?(&value, flag)
            }
            private var __spyable_updateValueIntFlagBoolCallsCount: Int = 0
            var updateValueIntFlagBoolCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "updateValueIntFlagBool")
                    return __spyable_updateValueIntFlagBoolCallsCount
                }
                set {
                    __spyable_updateValueIntFlagBoolCallsCount = newValue
                }
            }
            var updateValueIntFlagBoolCalled: Bool {
                return updateValueIntFlagBoolCallsCount > 0
            }
            private var __spyable_updateValueIntFlagBoolReceivedArguments: (value: Int, flag: Bool)?
            var updateValueIntFlagBoolReceivedArguments: (value: Int, flag: Bool)? {
                get {
                    __spyableLedger?.markVerified(self, "updateValueIntFlagBool")
                    return __spyable_updateValueIntFlagBoolReceivedArguments
                }
                set {
                    __spyable_updateValueIntFlagBoolReceivedArguments = newValue
                }
            }
            private var __spyable_updateValueIntFlagBoolReceivedInvocations: [(value: Int, flag: Bool)] = []
            var updateValueIntFlagBoolReceivedInvocations: [(value: Int, flag: Bool)] {
                get {
                    __spyableLedger?.markVerified(self, "updateValueIntFlagBool")
                    return __spyable_updateValueIntFlagBoolReceivedInvocations
                }
                set {
                    __spyable_updateValueIntFlagBoolReceivedInvocations = newValue
                }
            }
            var updateValueIntFlagBoolClosure: ((Int, Bool) -> Void)?
            func update(value: Int, flag: Bool) {
                __spyableLedger?.record(self, "updateValueIntFlagBool", "InoutParametersProtocolSpy.update(value: Int, flag: Bool)")
                __spyable_updateValueIntFlagBoolCallsCount += 1
                __spyable_updateValueIntFlagBoolReceivedArguments = (value, flag)
                __spyable_updateValueIntFlagBoolReceivedInvocations.append((value, flag))
                updateValueIntFlagBoolClosure?(value, flag)
            }
            var processDatainoutDataBoolCallsCount = 0
            var processDatainoutDataBoolCalled: Bool {
                return processDatainoutDataBoolCallsCount > 0
            }
            var processDatainoutDataBoolReceivedData: Data?
            var processDatainoutDataBoolReceivedInvocations: [Data] = []
            var processDatainoutDataBoolReturnValue: Bool!
            var processDatainoutDataBoolClosure: ((inout Data) -> Bool)?
            func process(data: inout Data) -> Bool {
                processDatainoutDataBoolCallsCount += 1
                processDatainoutDataBoolReceivedData = (data)
                processDatainoutDataBoolReceivedInvocations.append((data))
                if processDatainoutDataBoolClosure != nil {
                    return processDatainoutDataBoolClosure!(&data)
                } else {
                    return processDatainoutDataBoolReturnValue
                }
            }
            var processDataDataBoolCallsCount = 0
            var processDataDataBoolCalled: Bool {
                return processDataDataBoolCallsCount > 0
            }
            var processDataDataBoolReceivedData: Data?
            var processDataDataBoolReceivedInvocations: [Data] = []
            var processDataDataBoolReturnValue: Bool!
            var processDataDataBoolClosure: ((Data) -> Bool)?
            func process(data: Data) -> Bool {
                processDataDataBoolCallsCount += 1
                processDataDataBoolReceivedData = (data)
                processDataDataBoolReceivedInvocations.append((data))
                if processDataDataBoolClosure != nil {
                    return processDataDataBoolClosure!(data)
                } else {
                    return processDataDataBoolReturnValue
                }
            }
            var processDatainoutDataStringCallsCount = 0
            var processDatainoutDataStringCalled: Bool {
                return processDatainoutDataStringCallsCount > 0
            }
            var processDatainoutDataStringReceivedData: Data?
            var processDatainoutDataStringReceivedInvocations: [Data] = []
            var processDatainoutDataStringReturnValue: String!
            var processDatainoutDataStringClosure: ((inout Data) -> String)?
            func process(data: inout Data) -> String {
                processDatainoutDataStringCallsCount += 1
                processDatainoutDataStringReceivedData = (data)
                processDatainoutDataStringReceivedInvocations.append((data))
                if processDatainoutDataStringClosure != nil {
                    return processDatainoutDataStringClosure!(&data)
                } else {
                    return processDatainoutDataStringReturnValue
                }
            }
            private var __spyable_swapFirstinoutIntSecondinoutIntCallsCount: Int = 0
            var swapFirstinoutIntSecondinoutIntCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutIntSecondinoutInt")
                    return __spyable_swapFirstinoutIntSecondinoutIntCallsCount
                }
                set {
                    __spyable_swapFirstinoutIntSecondinoutIntCallsCount = newValue
                }
            }
            var swapFirstinoutIntSecondinoutIntCalled: Bool {
                return swapFirstinoutIntSecondinoutIntCallsCount > 0
            }
            private var __spyable_swapFirstinoutIntSecondinoutIntReceivedArguments: (first: Int, second: Int)?
            var swapFirstinoutIntSecondinoutIntReceivedArguments: (first: Int, second: Int)? {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutIntSecondinoutInt")
                    return __spyable_swapFirstinoutIntSecondinoutIntReceivedArguments
                }
                set {
                    __spyable_swapFirstinoutIntSecondinoutIntReceivedArguments = newValue
                }
            }
            private var __spyable_swapFirstinoutIntSecondinoutIntReceivedInvocations: [(first: Int, second: Int)] = []
            var swapFirstinoutIntSecondinoutIntReceivedInvocations: [(first: Int, second: Int)] {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutIntSecondinoutInt")
                    return __spyable_swapFirstinoutIntSecondinoutIntReceivedInvocations
                }
                set {
                    __spyable_swapFirstinoutIntSecondinoutIntReceivedInvocations = newValue
                }
            }
            var swapFirstinoutIntSecondinoutIntClosure: ((inout Int, inout Int) -> Void)?
            func swap(first: inout Int, second: inout Int) {
                __spyableLedger?.record(self, "swapFirstinoutIntSecondinoutInt", "InoutParametersProtocolSpy.swap(first: inout Int, second: inout Int)")
                __spyable_swapFirstinoutIntSecondinoutIntCallsCount += 1
                __spyable_swapFirstinoutIntSecondinoutIntReceivedArguments = (first, second)
                __spyable_swapFirstinoutIntSecondinoutIntReceivedInvocations.append((first, second))
                swapFirstinoutIntSecondinoutIntClosure?(&first, &second)
            }
            private var __spyable_swapFirstinoutStringSecondinoutStringCallsCount: Int = 0
            var swapFirstinoutStringSecondinoutStringCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutStringSecondinoutString")
                    return __spyable_swapFirstinoutStringSecondinoutStringCallsCount
                }
                set {
                    __spyable_swapFirstinoutStringSecondinoutStringCallsCount = newValue
                }
            }
            var swapFirstinoutStringSecondinoutStringCalled: Bool {
                return swapFirstinoutStringSecondinoutStringCallsCount > 0
            }
            private var __spyable_swapFirstinoutStringSecondinoutStringReceivedArguments: (first: String, second: String)?
            var swapFirstinoutStringSecondinoutStringReceivedArguments: (first: String, second: String)? {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutStringSecondinoutString")
                    return __spyable_swapFirstinoutStringSecondinoutStringReceivedArguments
                }
                set {
                    __spyable_swapFirstinoutStringSecondinoutStringReceivedArguments = newValue
                }
            }
            private var __spyable_swapFirstinoutStringSecondinoutStringReceivedInvocations: [(first: String, second: String)] = []
            var swapFirstinoutStringSecondinoutStringReceivedInvocations: [(first: String, second: String)] {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstinoutStringSecondinoutString")
                    return __spyable_swapFirstinoutStringSecondinoutStringReceivedInvocations
                }
                set {
                    __spyable_swapFirstinoutStringSecondinoutStringReceivedInvocations = newValue
                }
            }
            var swapFirstinoutStringSecondinoutStringClosure: ((inout String, inout String) -> Void)?
            func swap(first: inout String, second: inout String) {
                __spyableLedger?.record(self, "swapFirstinoutStringSecondinoutString", "InoutParametersProtocolSpy.swap(first: inout String, second: inout String)")
                __spyable_swapFirstinoutStringSecondinoutStringCallsCount += 1
                __spyable_swapFirstinoutStringSecondinoutStringReceivedArguments = (first, second)
                __spyable_swapFirstinoutStringSecondinoutStringReceivedInvocations.append((first, second))
                swapFirstinoutStringSecondinoutStringClosure?(&first, &second)
            }
            private var __spyable_swapFirstSecondThirdCallsCount: Int = 0
            var swapFirstSecondThirdCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstSecondThird")
                    return __spyable_swapFirstSecondThirdCallsCount
                }
                set {
                    __spyable_swapFirstSecondThirdCallsCount = newValue
                }
            }
            var swapFirstSecondThirdCalled: Bool {
                return swapFirstSecondThirdCallsCount > 0
            }
            private var __spyable_swapFirstSecondThirdReceivedArguments: (first: Int, second: Int, third: Int)?
            var swapFirstSecondThirdReceivedArguments: (first: Int, second: Int, third: Int)? {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstSecondThird")
                    return __spyable_swapFirstSecondThirdReceivedArguments
                }
                set {
                    __spyable_swapFirstSecondThirdReceivedArguments = newValue
                }
            }
            private var __spyable_swapFirstSecondThirdReceivedInvocations: [(first: Int, second: Int, third: Int)] = []
            var swapFirstSecondThirdReceivedInvocations: [(first: Int, second: Int, third: Int)] {
                get {
                    __spyableLedger?.markVerified(self, "swapFirstSecondThird")
                    return __spyable_swapFirstSecondThirdReceivedInvocations
                }
                set {
                    __spyable_swapFirstSecondThirdReceivedInvocations = newValue
                }
            }
            var swapFirstSecondThirdClosure: ((inout Int, inout Int, inout Int) -> Void)?
            func swap(first: inout Int, second: inout Int, third: inout Int) {
                __spyableLedger?.record(self, "swapFirstSecondThird", "InoutParametersProtocolSpy.swap(first:second:third:)")
                __spyable_swapFirstSecondThirdCallsCount += 1
                __spyable_swapFirstSecondThirdReceivedArguments = (first, second, third)
                __spyable_swapFirstSecondThirdReceivedInvocations.append((first, second, third))
                swapFirstSecondThirdClosure?(&first, &second, &third)
            }
            var transformInputinoutStringOptionsDictionaryStringAnyIntCallsCount = 0
            var transformInputinoutStringOptionsDictionaryStringAnyIntCalled: Bool {
                return transformInputinoutStringOptionsDictionaryStringAnyIntCallsCount > 0
            }
            var transformInputinoutStringOptionsDictionaryStringAnyIntReceivedArguments: (input: String, options: [String: Any])?
            var transformInputinoutStringOptionsDictionaryStringAnyIntReceivedInvocations: [(input: String, options: [String: Any])] = []
            var transformInputinoutStringOptionsDictionaryStringAnyIntReturnValue: Int!
            var transformInputinoutStringOptionsDictionaryStringAnyIntClosure: ((inout String, [String: Any]) -> Int)?
            func transform(input: inout String, options: [String: Any]) -> Int {
                transformInputinoutStringOptionsDictionaryStringAnyIntCallsCount += 1
                transformInputinoutStringOptionsDictionaryStringAnyIntReceivedArguments = (input, options)
                transformInputinoutStringOptionsDictionaryStringAnyIntReceivedInvocations.append((input, options))
                if transformInputinoutStringOptionsDictionaryStringAnyIntClosure != nil {
                    return transformInputinoutStringOptionsDictionaryStringAnyIntClosure!(&input, options)
                } else {
                    return transformInputinoutStringOptionsDictionaryStringAnyIntReturnValue
                }
            }
            var transformInputStringOptionsDictionaryStringAnyIntCallsCount = 0
            var transformInputStringOptionsDictionaryStringAnyIntCalled: Bool {
                return transformInputStringOptionsDictionaryStringAnyIntCallsCount > 0
            }
            var transformInputStringOptionsDictionaryStringAnyIntReceivedArguments: (input: String, options: [String: Any])?
            var transformInputStringOptionsDictionaryStringAnyIntReceivedInvocations: [(input: String, options: [String: Any])] = []
            var transformInputStringOptionsDictionaryStringAnyIntReturnValue: Int!
            var transformInputStringOptionsDictionaryStringAnyIntClosure: ((String, [String: Any]) -> Int)?
            func transform(input: String, options: [String: Any]) -> Int {
                transformInputStringOptionsDictionaryStringAnyIntCallsCount += 1
                transformInputStringOptionsDictionaryStringAnyIntReceivedArguments = (input, options)
                transformInputStringOptionsDictionaryStringAnyIntReceivedInvocations.append((input, options))
                if transformInputStringOptionsDictionaryStringAnyIntClosure != nil {
                    return transformInputStringOptionsDictionaryStringAnyIntClosure!(input, options)
                } else {
                    return transformInputStringOptionsDictionaryStringAnyIntReturnValue
                }
            }
            var transformInputinoutStringOptionsDictionaryStringAnyStringCallsCount = 0
            var transformInputinoutStringOptionsDictionaryStringAnyStringCalled: Bool {
                return transformInputinoutStringOptionsDictionaryStringAnyStringCallsCount > 0
            }
            var transformInputinoutStringOptionsDictionaryStringAnyStringReceivedArguments: (input: String, options: [String: Any])?
            var transformInputinoutStringOptionsDictionaryStringAnyStringReceivedInvocations: [(input: String, options: [String: Any])] = []
            var transformInputinoutStringOptionsDictionaryStringAnyStringReturnValue: String!
            var transformInputinoutStringOptionsDictionaryStringAnyStringClosure: ((inout String, [String: Any]) -> String)?
            func transform(input: inout String, options: [String: Any]) -> String {
                transformInputinoutStringOptionsDictionaryStringAnyStringCallsCount += 1
                transformInputinoutStringOptionsDictionaryStringAnyStringReceivedArguments = (input, options)
                transformInputinoutStringOptionsDictionaryStringAnyStringReceivedInvocations.append((input, options))
                if transformInputinoutStringOptionsDictionaryStringAnyStringClosure != nil {
                    return transformInputinoutStringOptionsDictionaryStringAnyStringClosure!(&input, options)
                } else {
                    return transformInputinoutStringOptionsDictionaryStringAnyStringReturnValue
                }
            }
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringCallsCount = 0
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringCalled: Bool {
                return transformInputinoutStringOptionsinoutDictionaryStringAnyStringCallsCount > 0
            }
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringReceivedArguments: (input: String, options: [String: Any])?
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringReceivedInvocations: [(input: String, options: [String: Any])] = []
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringReturnValue: String!
            var transformInputinoutStringOptionsinoutDictionaryStringAnyStringClosure: ((inout String, inout [String: Any]) -> String)?
            func transform(input: inout String, options: inout [String: Any]) -> String {
                transformInputinoutStringOptionsinoutDictionaryStringAnyStringCallsCount += 1
                transformInputinoutStringOptionsinoutDictionaryStringAnyStringReceivedArguments = (input, options)
                transformInputinoutStringOptionsinoutDictionaryStringAnyStringReceivedInvocations.append((input, options))
                if transformInputinoutStringOptionsinoutDictionaryStringAnyStringClosure != nil {
                    return transformInputinoutStringOptionsinoutDictionaryStringAnyStringClosure!(&input, &options)
                } else {
                    return transformInputinoutStringOptionsinoutDictionaryStringAnyStringReturnValue
                }
            }
            private var __spyable_configureSettingsinoutDictionaryStringAnyCallsCount: Int = 0
            var configureSettingsinoutDictionaryStringAnyCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsinoutDictionaryStringAny")
                    return __spyable_configureSettingsinoutDictionaryStringAnyCallsCount
                }
                set {
                    __spyable_configureSettingsinoutDictionaryStringAnyCallsCount = newValue
                }
            }
            var configureSettingsinoutDictionaryStringAnyCalled: Bool {
                return configureSettingsinoutDictionaryStringAnyCallsCount > 0
            }
            private var __spyable_configureSettingsinoutDictionaryStringAnyReceivedSettings: [String: Any]?
            var configureSettingsinoutDictionaryStringAnyReceivedSettings: [String: Any]? {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsinoutDictionaryStringAny")
                    return __spyable_configureSettingsinoutDictionaryStringAnyReceivedSettings
                }
                set {
                    __spyable_configureSettingsinoutDictionaryStringAnyReceivedSettings = newValue
                }
            }
            private var __spyable_configureSettingsinoutDictionaryStringAnyReceivedInvocations: [[String: Any]] = []
            var configureSettingsinoutDictionaryStringAnyReceivedInvocations: [[String: Any]] {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsinoutDictionaryStringAny")
                    return __spyable_configureSettingsinoutDictionaryStringAnyReceivedInvocations
                }
                set {
                    __spyable_configureSettingsinoutDictionaryStringAnyReceivedInvocations = newValue
                }
            }
            var configureSettingsinoutDictionaryStringAnyThrowableError: (any Error)?
            var configureSettingsinoutDictionaryStringAnyClosure: ((inout [String: Any]) async throws -> Void)?
            func configure(settings: inout [String: Any]) async throws {
                __spyableLedger?.record(self, "configureSettingsinoutDictionaryStringAny", "InoutParametersProtocolSpy.configure(settings: inout [String: Any])")
                __spyable_configureSettingsinoutDictionaryStringAnyCallsCount += 1
                __spyable_configureSettingsinoutDictionaryStringAnyReceivedSettings = (settings)
                __spyable_configureSettingsinoutDictionaryStringAnyReceivedInvocations.append((settings))
                if let configureSettingsinoutDictionaryStringAnyThrowableError {
                    throw configureSettingsinoutDictionaryStringAnyThrowableError
                }
                try await configureSettingsinoutDictionaryStringAnyClosure?(&settings)
            }
            private var __spyable_configureSettingsDictionaryStringAnyCallsCount: Int = 0
            var configureSettingsDictionaryStringAnyCallsCount: Int {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsDictionaryStringAny")
                    return __spyable_configureSettingsDictionaryStringAnyCallsCount
                }
                set {
                    __spyable_configureSettingsDictionaryStringAnyCallsCount = newValue
                }
            }
            var configureSettingsDictionaryStringAnyCalled: Bool {
                return configureSettingsDictionaryStringAnyCallsCount > 0
            }
            private var __spyable_configureSettingsDictionaryStringAnyReceivedSettings: [String: Any]?
            var configureSettingsDictionaryStringAnyReceivedSettings: [String: Any]? {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsDictionaryStringAny")
                    return __spyable_configureSettingsDictionaryStringAnyReceivedSettings
                }
                set {
                    __spyable_configureSettingsDictionaryStringAnyReceivedSettings = newValue
                }
            }
            private var __spyable_configureSettingsDictionaryStringAnyReceivedInvocations: [[String: Any]] = []
            var configureSettingsDictionaryStringAnyReceivedInvocations: [[String: Any]] {
                get {
                    __spyableLedger?.markVerified(self, "configureSettingsDictionaryStringAny")
                    return __spyable_configureSettingsDictionaryStringAnyReceivedInvocations
                }
                set {
                    __spyable_configureSettingsDictionaryStringAnyReceivedInvocations = newValue
                }
            }
            var configureSettingsDictionaryStringAnyThrowableError: (any Error)?
            var configureSettingsDictionaryStringAnyClosure: (([String: Any]) async throws -> Void)?
            func configure(settings: [String: Any]) async throws {
                __spyableLedger?.record(self, "configureSettingsDictionaryStringAny", "InoutParametersProtocolSpy.configure(settings: [String: Any])")
                __spyable_configureSettingsDictionaryStringAnyCallsCount += 1
                __spyable_configureSettingsDictionaryStringAnyReceivedSettings = (settings)
                __spyable_configureSettingsDictionaryStringAnyReceivedInvocations.append((settings))
                if let configureSettingsDictionaryStringAnyThrowableError {
                    throw configureSettingsDictionaryStringAnyThrowableError
                }
                try await configureSettingsDictionaryStringAnyClosure?(settings)
            }
            var configureSettingsinoutDictionaryStringAnyBoolCallsCount = 0
            var configureSettingsinoutDictionaryStringAnyBoolCalled: Bool {
                return configureSettingsinoutDictionaryStringAnyBoolCallsCount > 0
            }
            var configureSettingsinoutDictionaryStringAnyBoolReceivedSettings: [String: Any]?
            var configureSettingsinoutDictionaryStringAnyBoolReceivedInvocations: [[String: Any]] = []
            var configureSettingsinoutDictionaryStringAnyBoolThrowableError: (any Error)?
            var configureSettingsinoutDictionaryStringAnyBoolReturnValue: Bool!
            var configureSettingsinoutDictionaryStringAnyBoolClosure: ((inout [String: Any]) throws -> Bool)?
            func configure(settings: inout [String: Any]) throws -> Bool {
                configureSettingsinoutDictionaryStringAnyBoolCallsCount += 1
                configureSettingsinoutDictionaryStringAnyBoolReceivedSettings = (settings)
                configureSettingsinoutDictionaryStringAnyBoolReceivedInvocations.append((settings))
                if let configureSettingsinoutDictionaryStringAnyBoolThrowableError {
                    throw configureSettingsinoutDictionaryStringAnyBoolThrowableError
                }
                if configureSettingsinoutDictionaryStringAnyBoolClosure != nil {
                    return try configureSettingsinoutDictionaryStringAnyBoolClosure!(&settings)
                } else {
                    return configureSettingsinoutDictionaryStringAnyBoolReturnValue
                }
            }
            var configureSettingsDictionaryStringAnyBoolCallsCount = 0
            var configureSettingsDictionaryStringAnyBoolCalled: Bool {
                return configureSettingsDictionaryStringAnyBoolCallsCount > 0
            }
            var configureSettingsDictionaryStringAnyBoolReceivedSettings: [String: Any]?
            var configureSettingsDictionaryStringAnyBoolReceivedInvocations: [[String: Any]] = []
            var configureSettingsDictionaryStringAnyBoolThrowableError: (any Error)?
            var configureSettingsDictionaryStringAnyBoolReturnValue: Bool!
            var configureSettingsDictionaryStringAnyBoolClosure: (([String: Any]) throws -> Bool)?
            func configure(settings: [String: Any]) throws -> Bool {
                configureSettingsDictionaryStringAnyBoolCallsCount += 1
                configureSettingsDictionaryStringAnyBoolReceivedSettings = (settings)
                configureSettingsDictionaryStringAnyBoolReceivedInvocations.append((settings))
                if let configureSettingsDictionaryStringAnyBoolThrowableError {
                    throw configureSettingsDictionaryStringAnyBoolThrowableError
                }
                if configureSettingsDictionaryStringAnyBoolClosure != nil {
                    return try configureSettingsDictionaryStringAnyBoolClosure!(settings)
                } else {
                    return configureSettingsDictionaryStringAnyBoolReturnValue
                }
            }
        }
        #endif
        """,
      macros: sut
    )
  }
}
