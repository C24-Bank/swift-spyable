import SwiftSyntax
import XCTest

@testable import SpyableMacro

final class UT_FunctionDeclSyntaxExtensions: XCTestCase {

  // MARK: - genericTypes

  func testGenericTypes_WithGenerics() throws {
    let protocolFunctionDeclaration = try FunctionDeclSyntax(
      """
      func foo<T, U>() -> T
      """
    ) {}

    XCTAssertEqual(protocolFunctionDeclaration.genericTypes, ["T", "U"])
  }

  func testGenericTypes_WithoutGenerics() throws {
    let protocolFunctionDeclaration = try FunctionDeclSyntax(
      """
      func foo() -> T
      """
    ) {}

    XCTAssertTrue(protocolFunctionDeclaration.genericTypes.isEmpty)
  }

  // MARK: - forceCastType

  func testForceCastType_WithGeneric() throws {
    let protocolFunctionDeclaration = try FunctionDeclSyntax(
      """
      func foo<T>() -> T
      """
    ) {}

    XCTAssertEqual(
      try XCTUnwrap(protocolFunctionDeclaration.forceCastType).description,
      TypeSyntax(stringLiteral: "T").description
    )
  }

  func testForceCastType_WithoutGeneric() throws {
    let protocolFunctionDeclaration = try FunctionDeclSyntax(
      """
      func foo() -> T
      """
    ) {}

    XCTAssertNil(protocolFunctionDeclaration.forceCastType)
  }

  // MARK: - isCommand

  func testIsCommand_VoidSpellings() throws {
    for returnClause in [
      "", "-> Void", "-> ()", "-> Swift.Void", "-> (Void)", "-> (())", "-> (Swift.Void)",
      "-> ((Void))",
    ] {
      let functionDeclaration = try FunctionDeclSyntax("func foo() \(raw: returnClause)") {}
      XCTAssertTrue(functionDeclaration.isCommand, returnClause)
    }
  }

  func testIsCommand_ValueReturningSpellings() throws {
    for returnClause in [
      "-> Int", "-> (Int)", "-> (Void, Void)", "-> Void?", "-> Swift.Int", "-> Foo.Void",
      "-> (Int) -> Void",
    ] {
      let functionDeclaration = try FunctionDeclSyntax("func foo() \(raw: returnClause)") {}
      XCTAssertFalse(functionDeclaration.isCommand, returnClause)
    }
  }
}
