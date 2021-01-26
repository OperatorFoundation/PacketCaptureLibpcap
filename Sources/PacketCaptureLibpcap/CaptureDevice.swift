import Foundation
import PacketStream
import SwiftPCAP

public enum CaptureDeviceError: Error
{
    case openFailed
}

public class CaptureDevice: PacketStream
{
    let interface: String
    var pcap: SwiftPCAP.Base?

    public init?(interface: String)
    {
        self.interface = interface
    }

    public func startCapture() throws
    {
        do
        {
            let live = try SwiftPCAP.Live(interface: interface)
            self.pcap = live
        }
        catch (let liveError)
        {
            print("Error opening the capture device: \(liveError)")
            throw liveError
        }
    }

    public func nextCaptureResult() -> CaptureResult?
    {
        guard let pcap = self.pcap else {return nil}
        guard let data = pcap.nextPacket() else {return nil}

        let timestamp = pcap.currentHeader.ts
        let seconds = UInt64(timestamp.tv_sec) //convert seconds to microsecs
        let microSecs = UInt64(timestamp.tv_usec)
        let totalMicroSecs = seconds * UInt64(1e6) + microSecs
        let totalSeconds = totalMicroSecs / 1000000
        let date = Date(timeIntervalSince1970: TimeInterval(totalSeconds))

        return CaptureResult(packets: [TimestampedPacket(timestamp: date, payload: data)], dropped: 0)
    }

    public func stopCapture() throws
    {
        self.pcap?.close()
        self.pcap = nil
    }
}
