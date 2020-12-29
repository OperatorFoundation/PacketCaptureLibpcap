import Foundation
import PacketStream
import SwiftPCAP

public class CaptureDevice: PacketStream
{
    let pcap: SwiftPCAP.Base

    public init?(interface: String)
    {
        do
        {
            let live = try SwiftPCAP.Live(interface: interface)
            self.pcap = live
        }
        catch (let liveError)
        {
            print("Error opening the capture device: \(liveError)")
            return nil
        }
    }

    public func nextPacket() -> (Date, Data)
    {
        let bytes = pcap.nextPacket()
        let data = Data(bytes)

        let timestamp = pcap.currentHeader.ts
        let seconds = UInt64(timestamp.tv_sec) //convert seconds to microsecs
        let microSecs = UInt64(timestamp.tv_usec)
        let totalMicroSecs = seconds * UInt64(1e6) + microSecs
        let totalSeconds = totalMicroSecs / 1000000
        let date = Date(timeIntervalSince1970: TimeInterval(totalSeconds))

        return (date, data)
    }
}
