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

@Spyable
protocol Displaying {
  func display(text: Int, animated: Bool)
  func display(text: String, animated: Bool)
  func reset()
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

  func testOverloadedCommandsReportTheirParameterTypes() {
    let ledger = SpyableLedger()
    SpyableLedger.$current.withValue(ledger) {
      let spy = DisplayingSpy()
      spy.display(text: 1, animated: true)
      spy.display(text: "x", animated: true)
      spy.reset()
    }

    XCTAssertEqual(
      ledger.finish().map(\.description),
      [
        "DisplayingSpy.display(text: Int, animated: Bool)",
        "DisplayingSpy.display(text: String, animated: Bool)",
        "DisplayingSpy.reset()",
      ]
    )
  }
}
