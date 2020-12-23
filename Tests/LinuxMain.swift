import XCTest

import PacketCaptureLibpcapTests

var tests = [XCTestCaseEntry]()
tests += PacketCaptureLibpcapTests.allTests()
XCTMain(tests)
