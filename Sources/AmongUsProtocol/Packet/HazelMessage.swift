import Foundation

public struct HazelMessage: Equatable {
    public let length: UInt16
    public let tag: UInt8
    public let payload: RootMessage
}

extension HazelMessage: CustomStringConvertible {
    public var description: String {
        "{Length: \(length), Tag: \(tag), Payload: \(payload)}"
    }
}
