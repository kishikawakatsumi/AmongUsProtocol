import Foundation

public struct Redirect: Equatable {
    public let ipAddress: String
    public let port: UInt16
}

extension Redirect: CustomStringConvertible {
    public var description: String {
        "{IP Address: \(ipAddress), Port: \(port)}"
    }
}
