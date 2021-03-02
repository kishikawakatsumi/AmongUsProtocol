import Foundation

public enum RootMessageType: UInt8 {
    case hostGame = 0x00
    case joinGame = 0x01
    case startGame = 0x02
    case removeGame = 0x03
    case removePlayer = 0x04
    case gameData = 0x05
    case gameDataTo = 0x06
    case joinedGame = 0x07
    case endGame = 0x08
    case getGameList = 0x09
    case alterGame = 0x0a
    case kickPlayer = 0x0b
    case waitForHost = 0x0c
    case redirect = 0x0d
    case reselectServer = 0x0e
    case getGameListV2 = 0x10
}
