import XCTest
import SwiftPCAP
@testable import PacketCaptureLibpcap

final class PacketCaptureLibpcapTests: XCTestCase
{
    func testPacketCaptureInit()
    {
        do
        {
            let interface = "en0"
            let _ = try SwiftPCAP.Live(interface: interface)
        }
        catch (let liveError)
        {
            print("Error opening the capture device: \(liveError)")
            XCTFail()
        }
    }

    static var allTests = [
        ("testPacketCaptureInit", testPacketCaptureInit),
    ]
}
