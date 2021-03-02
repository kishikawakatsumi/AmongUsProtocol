import XCTest
@testable import AmongUsProtocol

final class AmongUsProtocolTests: XCTestCase {
    func testReadPackedUInt32() throws {
        let raw = "cb22"
        let packet = try XCTUnwrap(Data(hex: raw))
        let buffer = ByteBuffer(packet)
        XCTAssertEqual(buffer.readPackedUInt32(), 4427)
    }

    func testParseRedirect() throws {
        let raw = "01000106000dac6bd5c23357"
        let packet = try XCTUnwrap(Data(hex: raw))

        let auPacket = try XCTUnwrap(PacketParser.parse(packet: packet))
        guard case .reliable(let reliable) = auPacket else {
            XCTFail()
            return
        }
        XCTAssertEqual(reliable.messages.count, 1)

        guard case .redirect(let redirect) = reliable.messages[0].payload else {
            XCTFail()
            return
        }

        XCTAssertEqual(redirect.ipAddress, "172.107.213.194")
        XCTAssertEqual(redirect.port, 22323)
    }

    func testParseReselectServer() throws {
        let raw = "0034000e01021600000d417369612d4d61737465722d318ba26fc40756d7061600000d417369612d4d61737465722d32ac6860630756d206"
        let packet = try XCTUnwrap(Data(hex: raw))

        let auPacket = try XCTUnwrap(PacketParser.parse(packet: packet))
        guard case .normal(let normal) = auPacket else {
            XCTFail()
            return
        }
        XCTAssertEqual(normal.messages.count, 1)

        guard case .reselectServer(let reselectServer) = normal.messages[0].payload else {
            XCTFail()
            return
        }

        XCTAssertEqual(reselectServer.masterServersLength, 2)
        XCTAssertEqual(reselectServer.masterServers.count, 2)

        XCTAssertEqual(reselectServer.masterServers[0].name, "Asia-Master-1")
        XCTAssertEqual(reselectServer.masterServers[0].ipAddress, "139.162.111.196")
        XCTAssertEqual(reselectServer.masterServers[0].port, 22023)
        XCTAssertEqual(reselectServer.masterServers[0].numberOfConnections, 855)

        XCTAssertEqual(reselectServer.masterServers[1].name, "Asia-Master-2")
        XCTAssertEqual(reselectServer.masterServers[1].ipAddress, "172.104.96.99")
        XCTAssertEqual(reselectServer.masterServers[1].port, 22023)
        XCTAssertEqual(reselectServer.masterServers[1].numberOfConnections, 850)
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
