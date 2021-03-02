import Foundation

public enum PacketParser {
    public static func parse(packet: Data) -> Packet? {
        guard packet.count > 0 else { return nil }
        let buffer = ByteBuffer(packet)

        let opcode = buffer.read(UInt8.self)
        guard let packetType = PacketType(rawValue: opcode) else { return nil }

        switch packetType {
        case .normal:
            guard let normal = parseNormalPacket(packet: packet) else { return nil }
            return .normal(normal)
        case .reliable:
            guard let reliable = parseReliablePacket(packet: packet) else { return nil }
            return .reliable(reliable)
        case .hello:
            guard let hello = parseHelloPacket(packet: packet) else { return nil }
            return .hello(hello)
        case .disconnect:
            return .disconnect
        case .acknowledgement:
            guard let acknowledgement = parseAcknowledgementPacket(packet: packet) else { return nil }
            return .acknowledgement(acknowledgement)
        case .fragment:
            return .fragment
        case .ping:
            guard let ping = parsePingPacket(packet: packet) else { return nil }
            return .ping(ping)
        }
    }

    static func parseNormalPacket(packet: Data) -> NormalPacket? {
        guard packet.count > 1 else { return nil }
        let buffer = ByteBuffer(packet)
        
        let opcode = buffer.read(UInt8.self)
        let messages = parseRootMessages(buffer: buffer)

        return NormalPacket(
            opcode: opcode,
            messages: messages
        )
    }

    static func parseReliablePacket(packet: Data) -> ReliablePacket? {
        guard packet.count > 1 else { return nil }
        let buffer = ByteBuffer(packet)

        let opcode = buffer.read(UInt8.self)
        let nonce = buffer.read(UInt16.self).bigEndian
        let messages = parseRootMessages(buffer: buffer)

        return ReliablePacket(
            opcode: opcode,
            nonce: nonce,
            messages: messages
        )
    }

    static func parseHelloPacket(packet: Data) -> HelloPacket? {
        guard packet.count > 1 else { return nil }
        let buffer = ByteBuffer(packet)

        let opcode = buffer.read(UInt8.self)
        let nonce = buffer.read(UInt16.self).bigEndian
        let hazelVersion = buffer.read(UInt8.self)
        let clientVersion = decodeClientVersion(buffer.read(Int32.self))
        let username = buffer.read(String.self)

        return HelloPacket(
            opcode: opcode,
            nonce: nonce,
            hazelVersion: hazelVersion,
            clientVersion: clientVersion,
            username: username
        )
    }

    static func parseAcknowledgementPacket(packet: Data) -> AcknowledgementPacket? {
        guard packet.count > 1 else { return nil }
        let buffer = ByteBuffer(packet)

        let opcode = buffer.read(UInt8.self)
        let nonce = buffer.read(UInt16.self).bigEndian
        let missingPackets = buffer.read(UInt8.self)

        return AcknowledgementPacket(
            opcode: opcode,
            nonce: nonce,
            missingPackets: missingPackets
        )
    }

    static func parsePingPacket(packet: Data) -> PingPacket? {
        guard packet.count > 1 else { return nil }
        let buffer = ByteBuffer(packet)

        let opcode = buffer.read(UInt8.self)
        let nonce = buffer.read(UInt16.self).bigEndian

        return PingPacket(
            opcode: opcode,
            nonce: nonce
        )
    }

    static func parseRootMessages(buffer: ByteBuffer) -> [HazelMessage] {
        var messages = [HazelMessage]()

        while buffer.availableBytes > 1 {
            guard let message = parseRootMessage(buffer: buffer) else { continue }
            messages.append(message)
        }

        return messages
    }

    static func parseRootMessage(buffer: ByteBuffer) -> HazelMessage? {
        guard buffer.availableBytes > 1 else { return nil }
        let length = buffer.read(UInt16.self)

        guard buffer.availableBytes > 0 else { return nil }
        let tag = buffer.read(UInt8.self)

        guard buffer.availableBytes >= length else { return nil }
        let payload = buffer.read(Data.self, count: Int(length))

        let payloadBuffer = ByteBuffer(payload)

        guard let type = RootMessageType(rawValue: tag) else { return nil }
        switch type {
        case .hostGame:
            let payloadLength = Int(payloadBuffer.readPackedUInt32())
            guard payloadBuffer.availableBytes >= payloadLength else { return nil }

            let buffer = ByteBuffer(payloadBuffer.read(Data.self, count: payloadLength))
            let gameOptionsData = parseGameOptionsData(buffer: buffer)

            return HazelMessage(length: length, tag: tag, payload: .hostGame(gameOptionsData))
        case .joinGame:
            guard length == 5 else { return nil }
            let joinGame = parseJoinGame(buffer: payloadBuffer)
            
            return HazelMessage(length: length, tag: tag, payload: .joinGame(joinGame))
        case .startGame:
            guard length == 4 else { return nil }

            let gameId = payloadBuffer.read(Int32.self)
            let gameCode = gameIdToCode(gameId: gameId)

            return HazelMessage(length: length, tag: tag, payload: .startGame(gameCode))
        case .removeGame:
            break
        case .removePlayer:
            break
        case .gameData, .gameDataTo:
            guard payloadBuffer.availableBytes >= 4 else { return nil }
            let gameData = parseGameData(buffer: payloadBuffer)

            return HazelMessage(length: length, tag: tag, payload: .gameData(gameData))
        case .joinedGame:
            break
        case .endGame:
            guard length == 6 else { return nil }

            let gameId = payloadBuffer.read(Int32.self)
            let gameCode = gameIdToCode(gameId: gameId)
            let gameOverReason = payloadBuffer.read(UInt8.self)
            let showAd = payloadBuffer.read(Bool.self)

            return HazelMessage(
                length: length,
                tag: tag,
                payload: .endGame(
                    EndGame(
                        gameCode: gameCode,
                        gameOverReason: gameOverReason,
                        showAd: showAd
                    )
                )
            )
        case .getGameList:
            break
        case .alterGame:
            break
        case .kickPlayer:
            break
        case .waitForHost:
            break
        case .redirect:
            break
        case .reselectServer:
            break
        case .getGameListV2:
            break
        }

        return nil
    }

    static func parseGameOptionsData(buffer: ByteBuffer) -> GameOptionsData {
        let version = buffer.read(UInt8.self)

        let maxNumberOfPlayers = buffer.read(UInt8.self, default: 10)
        let keywords = buffer.read(UInt32.self, default: 1)
        let map = buffer.read(UInt8.self, default: 1)
        let playerSpeedModifier = buffer.read(Float.self, default: 1.0)
        let crewmateLightModifier = buffer.read(Float.self, default: 1.0)
        let impostorLightModifier = buffer.read(Float.self, default: 1.5)
        let killCooldown = buffer.read(Float.self, default: 45)
        let numberOfCommonTasks = buffer.read(UInt8.self, default: 1)
        let numberOfLongTasks = buffer.read(UInt8.self, default: 1)
        let numberOfShortTasks = buffer.read(UInt8.self, default: 2)
        let numberOfEmergencyMeetings = buffer.read(UInt32.self, default: 1)
        let numberOfImpostors = buffer.read(UInt8.self, default: 1)
        let killDistance = buffer.read(UInt8.self, default: 1)
        let discussionTime = buffer.read(UInt32.self, default: 15)
        let votingTime = buffer.read(UInt32.self, default: 120)
        let isDefaults = buffer.read(Bool.self, default: true)
        let emergencyCooldown = buffer.read(UInt8.self, default: 15)
        let confirmEjects = buffer.read(Bool.self, default: true)
        let visualTasks = buffer.read(Bool.self, default: true)
        let anonymousVotes = buffer.read(Bool.self, default: false)
        let taskBarUpdates = buffer.read(UInt8.self, default: 0)

        return GameOptionsData(
            version: version,
            maxNumberOfPlayers: maxNumberOfPlayers,
            keywords: keywords,
            map: map,
            playerSpeedModifier: playerSpeedModifier,
            crewmateLightModifier: crewmateLightModifier,
            impostorLightModifier: impostorLightModifier,
            killCooldown: killCooldown,
            numberOfCommonTasks: numberOfCommonTasks,
            numberOfLongTasks: numberOfLongTasks,
            numberOfShortTasks: numberOfShortTasks,
            numberOfEmergencyMeetings: numberOfEmergencyMeetings,
            numberOfImpostors: numberOfImpostors,
            killDistance: killDistance,
            discussionTime: discussionTime,
            votingTime: votingTime,
            isDefaults: isDefaults,
            emergencyCooldown: emergencyCooldown,
            confirmEjects: confirmEjects,
            visualTasks: visualTasks,
            anonymousVotes: anonymousVotes,
            taskBarUpdates: taskBarUpdates
        )
    }

    static func parseJoinGame(buffer: ByteBuffer) -> JoinGame {
        let gameId = buffer.read(Int32.self)
        let gameCode = gameIdToCode(gameId: gameId)
        let ownedMaps = buffer.read(UInt8.self)

        return JoinGame(gameCode: gameCode, ownedMaps: ownedMaps)
    }

    static func parseGameData(buffer: ByteBuffer) -> GameData {
        let gameId = buffer.read(Int32.self)
        let gameCode = gameIdToCode(gameId: gameId)

        let messages = GameDataParser.parseMessages(buffer: buffer)
        return GameData(gameCode: gameCode, messages: messages)
    }

    enum GameDataParser {
        static func parseMessages(buffer: ByteBuffer) -> [GameData.Message] {
            var messages = [GameData.Message]()
            while buffer.availableBytes > 1 {
                if let message = parseMessage(buffer: buffer) {
                    messages.append(message)
                }
            }
            return messages
        }

        static func parseMessage(buffer: ByteBuffer) -> GameData.Message? {
            guard buffer.availableBytes > 1 else { return nil }
            let length = buffer.read(UInt16.self)

            guard buffer.availableBytes > 0 else { return nil }
            let tag = buffer.read(UInt8.self)

            guard buffer.availableBytes >= length else { return nil }
            let payload = buffer.read(Data.self, count: Int(length))

            let payloadBuffer = ByteBuffer(payload)

            guard let messageType = GameData.MessageType(rawValue: tag) else { return nil }
            switch messageType {
            case .data:
                guard let data = MessageParser.parseData(buffer: payloadBuffer) else { return nil }
                return GameData.Message(length: length, tag: tag, payload: .data(data))
            case .rpc:
                guard let rpc = MessageParser.parseRPC(buffer: payloadBuffer) else { return nil }
                return GameData.Message(length: length, tag: tag, payload: .rpc(rpc))
            case .spawn:
                guard let spawn = MessageParser.parseSpawn(buffer: payloadBuffer) else { return nil }
                return GameData.Message(length: length, tag: tag, payload: .spawn(spawn))
            case .despawn:
                guard buffer.availableBytes > 0 else { return nil }
                let netId = payloadBuffer.readPackedUInt32()
                
                return GameData.Message(length: length, tag: tag, payload: .despawn(netId))
            case .sceneChange:
                break
            case .ready:
                break
            case .changeSettings:
                break
            }

            return nil
        }

        enum MessageParser {
            static func parseData(buffer: ByteBuffer) -> GameData.Message.Payload.Data? {
                guard buffer.availableBytes > 0 else { return nil }
                let netId = buffer.readPackedUInt32()

                return GameData.Message.Payload.Data(netId: netId)
            }

            static func parseRPC(buffer: ByteBuffer) -> GameData.Message.Payload.RPC? {
                guard buffer.availableBytes > 0 else { return nil }
                let senderNetId = buffer.readPackedUInt32()

                guard buffer.availableBytes > 0 else { return nil }
                let rpcCallId = buffer.read(UInt8.self)

                guard let rpcMessageType = RPCMessageType(rawValue: rpcCallId) else { return nil }
                switch rpcMessageType {
                case .playAnimation:
                    break
                case .completeTask:
                    break
                case .syncSettings:
                    let payloadLength = Int(buffer.readPackedUInt32())
                    guard buffer.availableBytes >= payloadLength else { return nil }

                    let buffer = ByteBuffer(buffer.read(Data.self, count: payloadLength))
                    let gameOptionsData = parseGameOptionsData(buffer: buffer)
                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .syncSettings(gameOptionsData)
                    )
                case .setInfected:
                    guard buffer.availableBytes > 0 else { return nil }

                    let impostorsLength = buffer.readPackedUInt32()
                    var impostors = [UInt8]()
                    for _ in 0..<impostorsLength {
                        guard buffer.availableBytes > 0 else { return nil }
                        impostors.append(buffer.read(UInt8.self))
                    }

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setInfected(
                            Infected(
                                impostorsLength: impostorsLength,
                                impostors: impostors
                            )
                        )
                    )
                case .exiled:
                    break
                case .checkName:
                    break
                case .setName:
                    guard buffer.availableBytes > 0 else { return nil }
                    let name = buffer.read(String.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setName(name)
                    )
                case .checkColor:
                    break
                case .setColor:
                    guard buffer.availableBytes > 0 else { return nil }
                    let colorId = buffer.read(UInt8.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setColor(colorId)
                    )
                case .setHat:
                    guard buffer.availableBytes > 0 else { return nil }
                    let hatId = buffer.readPackedUInt32()

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setHat(hatId)
                    )
                case .setSkin:
                    guard buffer.availableBytes > 0 else { return nil }
                    let skinId = buffer.readPackedUInt32()

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setSkin(skinId)
                    )
                case .reportDeadBody:
                    break
                case .murderPlayer:
                    break
                case .sendChat:
                    break
                case .startMeeting:
                    guard buffer.availableBytes > 0 else { return nil }
                    let victimPlayerId = buffer.read(UInt8.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .startMeeting(victimPlayerId)
                    )
                case .setScanner:
                    break
                case .sendChatNote:
                    guard buffer.availableBytes > 0 else { return nil }
                    let playerId = buffer.read(UInt8.self)

                    guard buffer.availableBytes > 0 else { return nil }
                    let chatNoteType = buffer.read(UInt8.self)
                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .sendChatNote(
                            ChatNote(
                                playerId: playerId,
                                chatNoteType: chatNoteType
                            )
                        )
                    )
                case .setPet:
                    guard buffer.availableBytes > 0 else { return nil }
                    let petId = buffer.readPackedUInt32()

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setPet(petId)
                    )
                case .setStartCounter:
                    guard buffer.availableBytes > 0 else { return nil }
                    let sequenceId = buffer.readPackedUInt32()

                    guard buffer.availableBytes == 1 else { return nil }
                    let timeRemaining = buffer.read(Int8.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setStartCounter(
                            StartCounter(
                                sequenceId: sequenceId,
                                timeRemaining: timeRemaining
                            )
                        )
                    )
                case .enterVent:
                    break
                case .exitVent:
                    break
                case .snapTo:
                    break
                case .close:
                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .close
                    )
                case .votingComplete:
                    guard buffer.availableBytes > 0 else { return nil }
                    let voteStatesLength = buffer.readPackedUInt32()

                    var voteStates = [UInt8]()
                    for _ in 0..<voteStatesLength {
                        guard buffer.availableBytes > 0 else { return nil }
                        voteStates.append(buffer.read(UInt8.self))
                    }

                    guard buffer.availableBytes == 2 else { return nil }
                    let exiledPlayerId = buffer.read(UInt8.self)
                    let isTie = buffer.read(Bool.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .votingComplete(
                            VotingComplete(
                                voteStatesLength: voteStatesLength,
                                voteStates: voteStates,
                                exiledPlayerId: exiledPlayerId,
                                isTie: isTie
                            )
                        )
                    )
                case .castVote:
                    guard buffer.availableBytes == 2 else { return nil }
                    let votingPlayerId = buffer.read(UInt8.self)
                    let suspectPlayerId = buffer.read(UInt8.self)

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .castVote(
                            CastVote(
                                votingPlayerId: votingPlayerId,
                                suspectPlayerId: suspectPlayerId
                            )
                        )
                    )
                case .clearVote:
                    break
                case .addVote:
                    break
                case .closeDoorsOfTyp:
                    break
                case .repairSystem:
                    break
                case .setTasks:
                    guard buffer.availableBytes > 0 else { return nil }
                    let playerId = buffer.read(UInt8.self)

                    guard buffer.availableBytes > 0 else { return nil }
                    let tasksLength = buffer.readPackedUInt32()

                    var tasks = [UInt8]()
                    for _ in 0..<tasksLength {
                        guard buffer.availableBytes > 0 else { return nil }
                        tasks.append(buffer.read(UInt8.self))
                    }

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .setTasks(
                            Tasks(
                                playerId: playerId,
                                tasksLength: tasksLength,
                                tasks: tasks
                            )
                        )
                    )
                case .updateGameData:
                    var gameData = [GameData.Message.Payload.RPC.GameData]()
                    while buffer.availableBytes > 0 {
                        gameData.append(
                            parseGameData(buffer: buffer)
                        )
                    }

                    return GameData.Message.Payload.RPC(
                        senderNetId: senderNetId,
                        rpcCallId: rpcCallId,
                        payload: .updateGameData(gameData)
                    )
                }

                return nil
            }

            static func parseGameData(buffer: ByteBuffer) -> GameData.Message.Payload.RPC.GameData {
                let netId = buffer.readPackedUInt32()
                let playersLength = buffer.readPackedUInt32()
                let playerId = buffer.read(UInt8.self)
                let name = buffer.read(String.self)
                let colorId = buffer.read(UInt8.self)
                let hatId = buffer.readPackedUInt32()
                let petId = buffer.readPackedUInt32()
                let skinId = buffer.readPackedUInt32()
                let flags = buffer.read(UInt8.self)

                let taskAmount = buffer.read(UInt8.self)
                var tasks = [GameData.Message.Payload.RPC.GameData.TaskInfo]()
                for _ in 0..<taskAmount {
                    tasks.append(
                        GameData.Message.Payload.RPC.GameData.TaskInfo(
                            taskId: buffer.readPackedUInt32(),
                            isCompleted: buffer.read(Bool.self)
                        )
                    )
                }

                return GameData.Message.Payload.RPC.GameData(
                    netId: netId,
                    playersLength: playersLength,
                    playerId: playerId,
                    name: name,
                    colorId: colorId,
                    hatId: hatId,
                    petId: petId,
                    skinId: skinId,
                    flags: flags,
                    taskInfo: tasks
                )
            }

            static func parseSpawn(buffer: ByteBuffer) -> GameData.Message.Payload.Spawn? {
                guard buffer.availableBytes > 0 else { return nil }
                guard let spawnType = SpawnType(rawValue: buffer.readPackedUInt32()) else { return nil }

                guard buffer.availableBytes > 0 else { return nil }
                let ownerId = Int32(buffer.readPackedUInt32())

                guard buffer.availableBytes > 0 else { return nil }
                guard let spawnFlags = SpawnFlag(rawValue: buffer.read(UInt8.self)) else { return nil }

                guard buffer.availableBytes > 0 else { return nil }
                let componentsLength = buffer.readPackedUInt32()

                var components = [GameData.Message.Payload.Spawn.Component]()

                switch spawnType {
                case .shipStatus:
                    break
                case .lobbyBehaviour:
                    break
                case .meetingHud, .gameData, .playerControl:
                    for _ in 0..<componentsLength {
                        guard let component = parseComponent(buffer: buffer) else { continue }
                        components.append(component)
                    }
                case .headquarters:
                    break
                case .planetMap:
                    break
                case .aprilShipStatus:
                    break
                }

                return GameData.Message.Payload.Spawn(
                    spawnType: spawnType,
                    ownerId: ownerId,
                    spawnFlags: spawnFlags,
                    componentsLength: componentsLength,
                    components: components
                )
            }

            static func parseComponent(buffer: ByteBuffer) -> GameData.Message.Payload.Spawn.Component? {
                guard buffer.availableBytes > 0 else { return nil }
                let netId = buffer.readPackedUInt32()

                guard buffer.availableBytes > 1 else { return nil }
                let length = buffer.read(UInt16.self)

                guard buffer.availableBytes > 0 else { return nil }
                let type = buffer.read(UInt8.self)

                guard buffer.availableBytes >= length else { return nil }
                var data = [UInt8]()
                for _ in 0..<length {
                    data.append(buffer.read(UInt8.self))
                }

                return GameData.Message.Payload.Spawn.Component(
                    netId: netId,
                    length: length,
                    type: type,
                    data: data
                )
            }
        }
    }
}
