import Foundation

public enum RootMessage: Equatable {
    case hostGame(GameOptionsData)
    case joinGame(JoinGame)
    case startGame(String)
    case gameData(GameData)
    case endGame(EndGame)
    case redirect(Redirect)
    case reselectServer(ReselectServer)
}

extension RootMessage: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hostGame(let gameOptionsData):
            return "{Host Game: \(gameOptionsData)}"
        case .joinGame(let joinGame):
            return "{Join Game: \(joinGame)}"
        case .startGame(let gameCode):
            return "{Start Game: \(gameCode)}"
        case .gameData(let gameData):
            return "{Game Data: \(gameData)}"
        case .endGame(let endGame):
            return "{End Game: \(endGame)}"
        case .redirect(let redirect):
            return "{Redirect: \(redirect)}"
        case .reselectServer(let reselectServer):
            return "{Reselect Server: \(reselectServer)}"
        }
    }
}
