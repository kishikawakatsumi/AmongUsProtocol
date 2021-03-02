import Foundation

public enum Color: UInt8 {
    case red = 0
    case blue = 1
    case green = 2
    case pink = 3
    case orange = 4
    case yellow = 5
    case grey = 6
    case white = 7
    case purple = 8
    case brown = 9
    case cyan = 10
    case lightGreen = 11
}

extension Color: CustomStringConvertible {
    public var description: String {
        switch self {
        case .red:
            return "Red"
        case .blue:
            return "Blue"
        case .green:
            return "Green"
        case .pink:
            return "Pink"
        case .orange:
            return "Orange"
        case .yellow:
            return "Yellow"
        case .grey:
            return "Grey"
        case .white:
            return "White"
        case .purple:
            return "Purple"
        case .brown:
            return "Brown"
        case .cyan:
            return "Cyan"
        case .lightGreen:
            return "Light Green"
        }
    }
}
