import Foundation

/// A per-test record of every *command* call (a method returning `Void`) made on generated spies,
/// so a test can fail on calls it never verified.
///
/// A spy captures `SpyableLedger.current` once, when it is initialized. While a ledger is
/// installed, each command call reports itself here, and reading that method's recorded calls on
/// the spy (`Called`, `CallsCount`, `Received…`, `ReceivedInvocations`) marks them verified.
/// Calls recorded after that read are unverified again. Methods returning a value are never
/// recorded. With no ledger installed, recording and verifying do nothing.
///
/// ### Usage:
/// ```swift
/// let ledger = SpyableLedger()
/// defer {
///     for call in ledger.finish() {
///         // report `call.description` (e.g. "ToastingSpy.showToast(_:)") as unverified
///     }
/// }
/// try await SpyableLedger.$current.withValue(ledger) {
///     try await body()
/// }
/// ```
///
/// ### Notes:
/// - The ledger keeps every spy it recorded a call for alive until `finish()` — and through it,
///   every argument that spy received — so an `ObjectIdentifier` is never reused for a different
///   spy mid-test. Always call `finish()`, also when the test throws (e.g. from a `defer`), or the
///   spies and the ledger keep each other alive.
/// - Only reads verify: `showToastCallsCount = 0` does not, while
///   `showToastReceivedInvocations.removeAll()` does, because it reads the array first.
/// - A read from inside the spy's own closure (`showToastClosure`) counts as verification too.
/// - Whether or not a ledger is installed, a command's bookkeeping writes private backing fields,
///   so a spy subclass's property observers (`didSet` on `showToastCallsCount`) no longer fire on
///   calls.
public final class SpyableLedger: @unchecked Sendable {
  /// The ledger spies created in the current task attach to, or `nil` when none is installed.
  @TaskLocal public static var current: SpyableLedger?

  /// A spy command whose calls were recorded but never read back.
  public struct UnverifiedCall: Sendable, Equatable {
    /// The spy and method, e.g. `"CoordinatorSpy.open(id:animated:)"`.
    public let description: String
    /// How many calls were recorded since the method was last verified.
    public let count: Int

    public init(description: String, count: Int) {
      self.description = description
      self.count = count
    }
  }

  private struct Key: Hashable {
    let spy: ObjectIdentifier
    let member: String
  }

  private struct Entry {
    let order: Int
    let description: String
    var count: Int
  }

  private let lock = NSLock()
  private var entries: [Key: Entry] = [:]
  private var spies: [ObjectIdentifier: AnyObject] = [:]
  private var nextOrder = 0
  private var isFinished = false

  public init() {}

  /// Records one call of `member` on `spy`. Ignored once the ledger is finished.
  public func record(_ spy: AnyObject, _ member: String, _ description: String) {
    lock.lock()
    defer { lock.unlock() }
    guard !isFinished else { return }

    let key = Key(spy: ObjectIdentifier(spy), member: member)
    spies[key.spy] = spy
    if entries[key] == nil {
      entries[key] = Entry(order: nextOrder, description: description, count: 0)
      nextOrder += 1
    }
    entries[key]!.count += 1
  }

  /// Marks every call of `member` on `spy` recorded so far as verified.
  public func markVerified(_ spy: AnyObject, _ member: String) {
    lock.lock()
    defer { lock.unlock() }
    entries[Key(spy: ObjectIdentifier(spy), member: member)] = nil
  }

  /// Closes the ledger and returns every call left unverified, in the order each was first
  /// recorded. Later calls to `record` are ignored.
  public func finish() -> [UnverifiedCall] {
    lock.lock()
    isFinished = true
    let leftovers = entries.values.sorted { $0.order < $1.order }
    let retainedSpies = spies
    entries = [:]
    spies = [:]
    lock.unlock()

    // Released outside the lock: a spy's teardown may end up calling back into this ledger.
    withExtendedLifetime(retainedSpies) {}
    return leftovers.map { UnverifiedCall(description: $0.description, count: $0.count) }
  }
}
