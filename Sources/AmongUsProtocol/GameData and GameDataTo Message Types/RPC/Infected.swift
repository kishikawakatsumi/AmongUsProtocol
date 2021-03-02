import Foundation

public struct Infected: Equatable {
    public let impostorsLength: UInt32
    public let impostors: [UInt8]
}

extension Infected: CustomStringConvertible {
    public var description: String {
        "{Impostors: \(impostors)}"
    }
}
