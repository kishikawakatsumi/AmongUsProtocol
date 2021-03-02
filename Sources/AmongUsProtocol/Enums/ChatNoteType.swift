import Foundation

public enum ChatNoteType: UInt8 {
    case didVote = 0
}

extension ChatNoteType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .didVote:
            return "Did vote"
        }
    }
}
