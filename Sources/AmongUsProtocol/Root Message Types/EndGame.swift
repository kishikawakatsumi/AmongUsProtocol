import Foundation

public struct EndGame: Equatable {
    public let gameCode: String
    public let gameOverReason: UInt8
    public let showAd: Bool
}

extension EndGame: CustomStringConvertible {
    public var description: String {
        "{Game code: \(gameCode), Game Over Reason: \(GameOverReason(rawValue: gameOverReason)?.description ?? "Unkown"), Show Ad: \(showAd)}"
    }
}
