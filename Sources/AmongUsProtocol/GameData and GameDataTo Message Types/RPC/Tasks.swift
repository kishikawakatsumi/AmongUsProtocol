import Foundation

public struct Tasks: Equatable {
    public let playerId: UInt8
    public let tasksLength: UInt32
    public let tasks: [UInt8]
}

extension Tasks: CustomStringConvertible {
    public var description: String {
        "{Player ID: \(playerId), Tasks: \(tasks)}"
    }
}
