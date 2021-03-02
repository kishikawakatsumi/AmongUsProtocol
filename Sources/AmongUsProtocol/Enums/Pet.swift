import Foundation

public enum Pet: UInt32 {
    case none = 0
    case alien = 1
    case miniCrewmate = 2
    case dog = 3
    case henryStickmin = 4
    case hamster = 5
    case robot = 6
    case ufo = 7
    case ellieRose = 8
    case squig = 9
    case bedcrab = 10
    case glitch = 11
}

extension Pet: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .alien:
            return "Alien"
        case .miniCrewmate:
            return "Mini Crewmate"
        case .dog:
            return "Dog"
        case .henryStickmin:
            return "Henry Stickmin"
        case .hamster:
            return "Hamster"
        case .robot:
            return "Robot"
        case .ufo:
            return "UFO"
        case .ellieRose:
            return "Ellie Rose"
        case .squig:
            return "Squig"
        case .bedcrab:
            return "Bedcrab"
        case .glitch:
            return "Glitch"
        }
    }
}
