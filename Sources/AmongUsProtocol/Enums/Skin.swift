import Foundation

public enum Skin: UInt32 {
    case none = 0
    case astronaut
    case captain
    case mechanic
    case military
    case police
    case scientist
    case suitBlack
    case suitWhite
    case wallGuard
    case hazmat
    case securityGuard
    case tarmac
    case miner
    case winter
    case archaeologist
}

extension Skin: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .astronaut:
            return "Astronaut"
        case .captain:
            return "Captain"
        case .mechanic:
            return "Mechanic"
        case .military:
            return "Military"
        case .police:
            return "Police"
        case .scientist:
            return "Scientist"
        case .suitBlack:
            return "Suit Black"
        case .suitWhite:
            return "Suit White"
        case .wallGuard:
            return "Wall Guard"
        case .hazmat:
            return "Hazmat"
        case .securityGuard:
            return "Security Guard"
        case .tarmac:
            return "Tarmac"
        case .miner:
            return "Miner"
        case .winter:
            return "Winter"
        case .archaeologist:
            return "Archaeologist"
        }
    }
}
