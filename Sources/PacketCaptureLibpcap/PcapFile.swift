//
//  PcapFile.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/23/20.
//

import Foundation
import PacketStream
import SwiftPCAP

public enum PcapFileError: Error
{
    case openFailed
}

public class PcapFile: PacketStream
{
    let path: String
    var pcap: SwiftPCAP.Base?

    public init?(path: String)
    {
        self.path = path
    }

    public func startCapture() throws
    {
        guard let live = try? SwiftPCAP.Offline(path: path) else
        {
            throw PcapFileError.openFailed
        }

        self.pcap = live
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
