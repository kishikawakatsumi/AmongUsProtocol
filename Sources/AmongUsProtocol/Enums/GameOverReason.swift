import Foundation

public enum GameOverReason: UInt8 {
    case crewmatesByVote = 0
    case crewmatesByTask = 1
    case impostorsByVote = 2
    case impostorsByKill = 3
    case impostorsBySabotage = 4
    case impostorDisconnect = 5
    case crewmateDisconnect = 6
}

extension GameOverReason: CustomStringConvertible {
    public var description: String {
        switch self {
        case .crewmatesByVote:
            return "Crewmates by vote"
        case .crewmatesByTask:
            return "Crewmates by task"
        case .impostorsByVote:
            return "Impostors by vote"
        case .impostorsByKill:
            return "Impostors by kill"
        case .impostorsBySabotage:
            return "Impostors by sabotage"
        case .impostorDisconnect:
            return "Impostor disconnect"
        case .crewmateDisconnect:
            return "Crewmate disconnect"
        }
    }
}
