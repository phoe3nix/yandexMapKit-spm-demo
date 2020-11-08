import XCTest
@testable import YandexMapsWrapper

final class YandexMapsWrapperTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(YandexMapsWrapper().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
