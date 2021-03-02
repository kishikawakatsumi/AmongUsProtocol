import Foundation

public struct ChatNote: Equatable {
    public let playerId: UInt8
    public let chatNoteType: UInt8
}

extension ChatNote: CustomStringConvertible {
    public var description: String {
        "{Player ID: \(playerId), Chat Note Type: \(chatNoteType)}"
    }
}
