import Foundation

public enum PacketType: UInt8 {
    case normal = 0x00
    case reliable = 0x01
    case hello = 0x08
    case disconnect = 0x09
    case acknowledgement = 0x0a
    case fragment = 0x0b
    case ping = 0x0c
}
