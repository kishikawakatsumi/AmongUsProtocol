import Foundation

public struct VotingComplete: Equatable {
    public let voteStatesLength: UInt32
    public let voteStates: [UInt8]
    public let exiledPlayerId: UInt8
    public let isTie: Bool
}

extension VotingComplete: CustomStringConvertible {
    public var description: String {
        "{Vote States: \(voteStates), Exiled Player ID: \(exiledPlayerId), Tie: \(isTie)}"
    }
}
