import Foundation

public struct GameOptionsData: Equatable {
    public let version: UInt8
    public let maxNumberOfPlayers: UInt8
    public let keywords: UInt32
    public let map: UInt8
    public let playerSpeedModifier: Float
    public let crewmateLightModifier: Float
    public let impostorLightModifier: Float
    public let killCooldown: Float
    public let numberOfCommonTasks: UInt8
    public let numberOfLongTasks: UInt8
    public let numberOfShortTasks: UInt8
    public let numberOfEmergencyMeetings: UInt32
    public let numberOfImpostors: UInt8
    public let killDistance: UInt8
    public let discussionTime: UInt32
    public let votingTime: UInt32
    public let isDefaults: Bool
    public let emergencyCooldown: UInt8
    public let confirmEjects: Bool
    public let visualTasks: Bool
    public let anonymousVotes: Bool
    public let taskBarUpdates: UInt8
}

extension GameOptionsData: CustomStringConvertible {
    public var description: String {
        "Max Number of Players: \(maxNumberOfPlayers), Keywords: \(keywords), Map: \(Map(rawValue: map)?.description ?? "???"), Player Speed Modifier: \(playerSpeedModifier), Crewmate Light Modifier: \(crewmateLightModifier), Impostor Light Modifier: \(impostorLightModifier), Kill Cooldown: \(killCooldown), Number of Common Tasks: \(numberOfCommonTasks), Number of Common Tasks: \(numberOfLongTasks), Number of Short Tasks: \(numberOfShortTasks), Number of Emergency Meetings: \(numberOfEmergencyMeetings), Number of Impostors: \(numberOfImpostors), Kill Distance: \(killDistance), Discussion Time: \(discussionTime), Voting Time: \(votingTime), Is Defaults: \(isDefaults), Emergency Cooldown: \(emergencyCooldown), Confirm Ejects: \(confirmEjects), Visual Tasks: \(visualTasks), Anonymous Votes: \(anonymousVotes), Task Bar Updates: \(taskBarUpdates)"
    }
}
