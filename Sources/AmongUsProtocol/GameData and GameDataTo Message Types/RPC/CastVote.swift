import Foundation

public struct CastVote: Equatable {
    public let votingPlayerId: UInt8
    public let suspectPlayerId: UInt8
}

extension CastVote: CustomStringConvertible {
    public var description: String {
        "{Voting Player ID: \(votingPlayerId), Suspect Player ID: \(suspectPlayerId)}"
    }
}
