import Foundation

public enum SpawnFlag: UInt8 {
    case none = 0
    case isClientCharacter = 1
}

extension SpawnFlag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .isClientCharacter:
            return "Client Character"
        }
    }
}
