import Foundation

public enum RPCMessageType: UInt8 {
    case playAnimation = 0x00
    case completeTask = 0x01
    case syncSettings = 0x02
    case setInfected = 0x03
    case exiled = 0x04
    case checkName = 0x05
    case setName = 0x06
    case checkColor = 0x07
    case setColor = 0x08
    case setHat = 0x09
    case setSkin = 0x0a
    case reportDeadBody = 0x0b
    case murderPlayer = 0x0c
    case sendChat = 0x0d
    case startMeeting = 0x0e
    case setScanner = 0x0f
    case sendChatNote = 0x10
    case setPet = 0x11
    case setStartCounter = 0x12
    case enterVent = 0x13
    case exitVent = 0x14
    case snapTo = 0x15
    case close = 0x16
    case votingComplete = 0x17
    case castVote = 0x18
    case clearVote = 0x19
    case addVote = 0x1a
    case closeDoorsOfTyp = 0x1b
    case repairSystem = 0x1c
    case setTasks = 0x1d
    case updateGameData = 0x1e
}
