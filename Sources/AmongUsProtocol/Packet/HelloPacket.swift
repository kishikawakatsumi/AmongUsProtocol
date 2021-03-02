import Foundation

public struct HelloPacket: Equatable {
    public let opcode: UInt8
    public let nonce: UInt16
    public let hazelVersion: UInt8
    public let clientVersion: String
    public let username: String
}

extension HelloPacket: CustomStringConvertible {
    public var description: String {
        "{Type: Hello, Nonce: \(nonce), Hazel Version: \(hazelVersion), Client Version: \(clientVersion), Username: \(username)}"
    }
}
