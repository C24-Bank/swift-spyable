import Foundation
import Spyable
import XCTest

@Spyable
protocol LikeGenerated {
  func load()
  func update(_ loadCallsCount: Int)
}

@Spyable(threadSafe: true)
protocol ThreadSafeLikeGenerated {
  func load()
  func update(_ loadCallsCount: Int)
}

/// Runs spies the macro generated, rather than the ledger alone.
final class UT_GeneratedSpies: XCTestCase {
  func testParameterNamedLikeAnotherCommandsCallsCountKeepsItsValue() {
    let spy = LikeGeneratedSpy()
    var closureArgument: Int?
    spy.updateClosure = { closureArgument = $0 }

    spy.load()
    spy.load()
    spy.update(42)

    XCTAssertEqual(spy.updateReceivedLoadCallsCount, 42)
    XCTAssertEqual(spy.updateReceivedInvocations, [42])
    XCTAssertEqual(closureArgument, 42)
  }

  func testThreadSafeParameterNamedLikeAnotherCommandsCallsCountKeepsItsValue() {
    let spy = ThreadSafeLikeGeneratedSpy()
    var closureArgument: Int?
    spy.updateClosure = { closureArgument = $0 }

    spy.load()
    spy.load()
    spy.update(42)

    XCTAssertEqual(spy.updateReceivedLoadCallsCount, 42)
    XCTAssertEqual(spy.updateReceivedInvocations, [42])
    XCTAssertEqual(closureArgument, 42)
  }
}
