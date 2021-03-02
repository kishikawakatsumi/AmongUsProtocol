import Foundation

public struct PingPacket: Equatable {
    public let opcode: UInt8
    public let nonce: UInt16
}
