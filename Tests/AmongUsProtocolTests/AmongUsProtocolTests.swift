import XCTest
@testable import AmongUsProtocol

final class AmongUsProtocolTests: XCTestCase {
    func testReadPackedUInt32() throws {
        let raw = "cb22"
        let packet = try XCTUnwrap(Data(hex: raw))
        let buffer = ByteBuffer(packet)
        XCTAssertEqual(buffer.readPackedUInt32(), 4427)
    }

    func testParseHelloPacket() throws {
        let raw = "080001004ae202030a496e6e657273726f7468"
        let packet = try XCTUnwrap(Data(hex: raw))

        let helloPacket = try XCTUnwrap(PacketParser.parseHelloPacket(packet: packet))
        XCTAssertEqual(helloPacket.opcode, PacketType.hello.rawValue)
        XCTAssertEqual(helloPacket.nonce, 1)
        XCTAssertEqual(helloPacket.hazelVersion, 0)
        XCTAssertEqual(helloPacket.clientVersion, "2020.11.17.0")
        XCTAssertEqual(helloPacket.username, "Innersroth")
    }
    
    func testParseDisconnectPacket() throws {
        let raw = "09"
        let packet = try XCTUnwrap(Data(hex: raw))

        let disconnectPacket = try XCTUnwrap(PacketParser.parse(packet: packet))
        XCTAssertEqual(disconnectPacket, .disconnect)
    }

    static var allTests = [
        ("testParseHelloPacket", testParseHelloPacket),
        ("testParseDisconnectPacket", testParseDisconnectPacket),
    ]
}
