//
//  PcapFile.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/23/20.
//

import Foundation
import PacketStream
import SwiftPCAP

public class PcapFile: PacketStream
{
    let pcap: SwiftPCAP.Base

    public init?(path: String)
    {
        guard let live = try? SwiftPCAP.Offline(path: path) else {return nil}
        self.pcap = live
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
