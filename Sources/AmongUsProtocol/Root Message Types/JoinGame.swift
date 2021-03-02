import Foundation

public struct JoinGame: Equatable {
    public let gameCode: String
    public let ownedMaps: UInt8
}

extension JoinGame: CustomStringConvertible {
    public var description: String {
        "{Game code: \(gameCode), Owned maps: \(ownedMaps)}"
    }
}
