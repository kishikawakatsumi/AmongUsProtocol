import Foundation

public struct AcknowledgementPacket: Equatable {
    public let opcode: UInt8
    public let nonce: UInt16
    public let missingPackets: UInt8
}
