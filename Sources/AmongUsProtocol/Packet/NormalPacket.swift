import Foundation

public struct NormalPacket: Equatable {
    public let opcode: UInt8
    public let messages: [HazelMessage]
}
