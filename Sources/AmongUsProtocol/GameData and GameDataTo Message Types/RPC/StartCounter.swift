import Foundation

public struct StartCounter: Equatable {
    public let sequenceId: UInt32
    public let timeRemaining: Int8
}

extension StartCounter: CustomStringConvertible {
    public var description: String {
        "{Sequence: \(sequenceId), Remaining: \(timeRemaining)}"
    }
}
