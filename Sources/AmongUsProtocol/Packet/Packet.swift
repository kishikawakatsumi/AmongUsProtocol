import Foundation

public enum Packet: Equatable {
    case normal(NormalPacket)
    case reliable(ReliablePacket)
    case hello(HelloPacket)
    case disconnect
    case acknowledgement(AcknowledgementPacket)
    case fragment
    case ping(PingPacket)
}
