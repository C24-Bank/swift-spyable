import Foundation
import Spyable
import XCTest

final class UT_SpyableLedger: XCTestCase {
  private final class Spy: Sendable {}

  private typealias Call = SpyableLedger.UnverifiedCall

  func testCurrentIsNilUnlessInstalled() {
    let ledger = SpyableLedger()

    XCTAssertNil(SpyableLedger.current)
    SpyableLedger.$current.withValue(ledger) {
      XCTAssertTrue(SpyableLedger.current === ledger)
    }
    XCTAssertNil(SpyableLedger.current)
  }

  func testFinishReturnsUnverifiedCallsInFirstRecordedOrder() {
    let ledger = SpyableLedger()
    let first = Spy()
    let second = Spy()

    ledger.record(first, "load", "FirstSpy.load()")
    ledger.record(second, "show", "SecondSpy.show(_:)")
    ledger.record(first, "load", "FirstSpy.load()")
    ledger.record(first, "reload", "FirstSpy.reload()")

    XCTAssertEqual(
      ledger.finish(),
      [
        Call(description: "FirstSpy.load()", count: 2),
        Call(description: "SecondSpy.show(_:)", count: 1),
        Call(description: "FirstSpy.reload()", count: 1),
      ]
    )
  }

  func testMarkVerifiedDropsOnlyThatSpysMember() {
    let ledger = SpyableLedger()
    let first = Spy()
    let second = Spy()

    ledger.record(first, "load", "FirstSpy.load()")
    ledger.record(first, "reload", "FirstSpy.reload()")
    ledger.record(second, "load", "SecondSpy.load()")
    ledger.markVerified(first, "load")

    XCTAssertEqual(
      ledger.finish(),
      [
        Call(description: "FirstSpy.reload()", count: 1),
        Call(description: "SecondSpy.load()", count: 1),
      ]
    )
  }

  func testCallsRecordedAfterVerificationAreUnverifiedAgain() {
    let ledger = SpyableLedger()
    let spy = Spy()

    ledger.record(spy, "load", "Spy.load()")
    ledger.record(spy, "load", "Spy.load()")
    ledger.record(spy, "reload", "Spy.reload()")
    ledger.markVerified(spy, "load")
    ledger.record(spy, "load", "Spy.load()")

    XCTAssertEqual(
      ledger.finish(),
      [
        Call(description: "Spy.reload()", count: 1),
        Call(description: "Spy.load()", count: 1),
      ]
    )
  }

  func testMarkVerifiedWithoutRecordedCallsIsHarmless() {
    let ledger = SpyableLedger()

    ledger.markVerified(Spy(), "load")

    XCTAssertEqual(ledger.finish(), [])
  }

  func testFinishClosesTheLedger() {
    let ledger = SpyableLedger()
    let spy = Spy()

    ledger.record(spy, "load", "Spy.load()")
    XCTAssertEqual(ledger.finish(), [Call(description: "Spy.load()", count: 1)])

    ledger.record(spy, "load", "Spy.load()")
    XCTAssertEqual(ledger.finish(), [])
  }

  func testRetainsRecordedSpiesUntilFinish() {
    let ledger = SpyableLedger()
    weak var weakSpy: Spy?

    do {
      let spy = Spy()
      weakSpy = spy
      ledger.record(spy, "load", "Spy.load()")
    }
    XCTAssertNotNil(weakSpy)

    _ = ledger.finish()
    XCTAssertNil(weakSpy)
  }

  func testConcurrentRecordingAndVerification() {
    let ledger = SpyableLedger()
    let spy = Spy()

    DispatchQueue.concurrentPerform(iterations: 1_000) { index in
      ledger.record(spy, "load", "Spy.load()")
      ledger.record(spy, "reload", "Spy.reload()")
      if index.isMultiple(of: 2) {
        ledger.markVerified(spy, "reload")
      }
    }
    ledger.markVerified(spy, "reload")

    XCTAssertEqual(ledger.finish(), [Call(description: "Spy.load()", count: 1_000)])
  }
}
