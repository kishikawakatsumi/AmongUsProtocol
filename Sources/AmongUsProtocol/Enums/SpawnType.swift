import Foundation

public enum SpawnType: UInt32 {
    case shipStatus = 0
    case meetingHud = 1
    case lobbyBehaviour = 2
    case gameData = 3
    case playerControl = 4
    case headquarters = 5
    case planetMap = 6
    case aprilShipStatus = 7
}

extension SpawnType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .shipStatus:
            return "Ship Status"
        case .meetingHud:
            return "Meeting HUD"
        case .lobbyBehaviour:
            return "Lobby Behaviour"
        case .gameData:
            return "Game Data"
        case .playerControl:
            return "Player Control"
        case .headquarters:
            return "Headquarters"
        case .planetMap:
            return "Planet Map"
        case .aprilShipStatus:
            return "April Ship Status"
        }
    }
}
