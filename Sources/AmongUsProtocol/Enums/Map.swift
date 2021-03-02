import Foundation

public enum Map: UInt8 {
    case theSkeld = 0
    case miraHq = 1
    case polus = 2
}

extension Map: CustomStringConvertible {
    public var description: String {
        switch self {
        case .theSkeld:
            return "The Skeld"
        case .miraHq:
            return "MIRA HQ"
        case .polus:
            return "Polus"
        }
    }
}
