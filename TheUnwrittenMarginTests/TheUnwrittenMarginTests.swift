import Testing
@testable import TheUnwrittenMargin

struct TheUnwrittenMarginTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
    }

}

// THROWAWAY: proves CI fails on a failing test (issue #2). Never merge.
@Test func deliberatelyFailingForCIProof() {
    #expect(1 == 2)
}
