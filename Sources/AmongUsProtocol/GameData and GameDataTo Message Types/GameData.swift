import Foundation

public struct GameData: Equatable {
    public let gameCode: String
    public let messages: [Message]

    enum MessageType: UInt8 {
        case data = 0x01
        case rpc = 0x02
        case spawn = 0x04
        case despawn = 0x05
        case sceneChange = 0x06
        case ready = 0x07
        case changeSettings = 0x08
    }

    public struct Message: Equatable {
        public let length: UInt16
        public let tag: UInt8
        public let payload: Payload

        public enum Payload: Equatable {
            case data(Data)
            case rpc(RPC)
            case spawn(Spawn)
            case despawn(UInt32)

            public struct Data: Equatable {
                public let netId: UInt32
            }

            public struct RPC: Equatable {
                public let senderNetId: UInt32
                public let rpcCallId: UInt8
                public let payload: Payload

                public enum Payload: Equatable {
                    case syncSettings(GameOptionsData)
                    case setInfected(Infected)
                    case setName(String)
                    case setColor(UInt8)
                    case setHat(UInt32)
                    case setSkin(UInt32)
                    case startMeeting(UInt8)
                    case sendChatNote(ChatNote)
                    case setPet(UInt32)
                    case setStartCounter(StartCounter)
                    case close
                    case votingComplete(VotingComplete)
                    case castVote(CastVote)
                    case setTasks(Tasks)
                    case updateGameData([GameData])
                }

                public struct GameData: Equatable {
                    public let netId: UInt32
                    public let playersLength: UInt32
                    public let playerId: UInt8
                    public let name: String
                    public let colorId: UInt8
                    public let hatId: UInt32
                    public let petId: UInt32
                    public let skinId: UInt32
                    public let flags: UInt8
                    public let taskInfo: [TaskInfo]

                    public  struct TaskInfo: Equatable {
                        public let taskId: UInt32
                        public let isCompleted: Bool
                    }
                }
            }

            public struct Spawn: Equatable {
                public let spawnType: SpawnType
                public let ownerId: Int32
                public let spawnFlags: SpawnFlag
                public let componentsLength: UInt32
                public let components: [Component]

                public struct Component: Equatable {
                    public let netId: UInt32
                    public let length: UInt16
                    public let type: UInt8
                    public let data: [UInt8]
                }
            }
        }
    }
}

extension GameData: CustomStringConvertible {
    public var description: String {
        "{Game Code: \(gameCode), Messages: \(messages)}"
    }
}

extension GameData.Message: CustomStringConvertible {
    public var description: String {
        "{Length: \(length), Tag: \(tag), Payload: \(payload)}"
    }
}

extension GameData.Message.Payload: CustomStringConvertible {
    public var description: String {
        switch self {
        case .data(let data):
            return "{Data: \(data)}"
        case .rpc(let rpc):
            return "{RPC: \(rpc)}"
        case .spawn(let spawn):
            return "{Spawn: \(spawn)}"
        case .despawn(let despawn):
            return "{Despawn: \(despawn)}"
        }
    }
}

extension GameData.Message.Payload.Data: CustomStringConvertible {
    public var description: String {
        "{Net ID: \(netId)}"
    }
}

extension GameData.Message.Payload.RPC: CustomStringConvertible {
    public var description: String {
        "{Sender Net ID: \(senderNetId), RPC Call ID: \(rpcCallId), Payload: \(payload)}"
    }
}

extension GameData.Message.Payload.RPC.Payload: CustomStringConvertible {
    public var description: String {
        switch self {
        case .syncSettings(let gameOptionsData):
            return "Sync Settings: \(gameOptionsData)"
        case .setInfected(let infected):
            return "Set Infected: \(infected)"
        case .setName(let name):
            return "Set Name: \(name)"
        case .setColor(let colorId):
            return "Set Color: \(Color(rawValue: colorId)?.description ?? "Unkown")"
        case .setHat(let hatId):
            return "Set Hat: \(Hat(rawValue: hatId)?.description ?? "Unkown")"
        case .setSkin(let skinId):
            return "Set Skin: \(Skin(rawValue: skinId)?.description ?? "Unkown")"
        case .startMeeting(let meeting):
            return "Start Meeting: \(meeting)"
        case .sendChatNote(let chatNote):
            return "Send Chat Note: \(chatNote)"
        case .setPet(let petId):
            return "Set Pet: \(Pet(rawValue: petId)?.description ?? "Unkown")"
        case .setStartCounter(let startCounter):
            return "Set Start Counter: \(startCounter)"
        case .close:
            return "Close"
        case .votingComplete(let votingComplete):
            return "Voting Complete: \(votingComplete)"
        case .castVote(let castVote):
            return "Cast Vote: \(castVote)"
        case .setTasks(let tasks):
            return "Set Tasks: \(tasks)"
        case .updateGameData(let gameData):
            return "Update Game Data: \(gameData)"
        }
    }
}

extension GameData.Message.Payload.RPC.GameData: CustomStringConvertible {
    public var description: String {
        let isDisconnected = (flags & 1) != 0
        let isImpostor = (flags & 2) != 0
        let isDead = (flags & 4) != 0
        return "{Net ID: \(netId), Player ID: \(playerId), Name: \(name), Color: \(Color(rawValue: colorId)?.description ?? "Unkown"), Hat: \(Hat(rawValue: hatId)?.description ?? "Unkown"), Pet: \(Pet(rawValue: petId)?.description ?? "Unkown"), Skin: \(Skin(rawValue: skinId)?.description ?? "Unkown"), Flags: (Disconnected?: \(isDisconnected), Impostor?: \(isImpostor), Dead?: \(isDead)), Tasks: \(taskInfo)}"
    }
}

extension GameData.Message.Payload.RPC.GameData.TaskInfo: CustomStringConvertible {
    public var description: String {
        "{Task ID: \(taskId), Completed: \(isCompleted)}"
    }
}

extension GameData.Message.Payload.Spawn.Component: CustomStringConvertible {
    public var description: String {
        "{Net ID: \(netId), Type: \(type), Data: \(data)}"
    }
}
