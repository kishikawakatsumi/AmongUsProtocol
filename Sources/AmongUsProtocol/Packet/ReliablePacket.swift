import Foundation

public struct ReliablePacket: Equatable {
    public let opcode: UInt8
    public let nonce: UInt16
    public let messages: [HazelMessage]
}

extension ReliablePacket: CustomStringConvertible {
    public var description: String {
        "{Type: Reliable, Nonce: \(nonce), Messages: \(messages)}"
    }
}
