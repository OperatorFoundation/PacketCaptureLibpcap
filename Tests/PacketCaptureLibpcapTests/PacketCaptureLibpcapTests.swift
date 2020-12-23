import XCTest
@testable import PacketCaptureLibpcap

final class PacketCaptureLibpcapTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PacketCaptureLibpcap().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
