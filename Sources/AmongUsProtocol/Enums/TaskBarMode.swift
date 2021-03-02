import Foundation

public enum TaskBarMode: UInt8 {
    case always = 0
    case meetings = 1
    case never = 2
}

extension TaskBarMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .always:
            return "Always"
        case .meetings:
            return "Meetings"
        case .never:
            return "Never"
        }
    }
}
