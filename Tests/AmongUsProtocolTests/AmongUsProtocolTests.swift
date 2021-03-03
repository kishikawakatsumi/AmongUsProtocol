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

    func testParseGameData() throws {
        let raw = "010004be0005000000000c000402feffffff0f00010100000112000403feffffff0f0002020100010003010001001e000404e68d01010304020001010005000001060a00010000ff7fff7fff7fff7f31000204022e040a01000000000000803f0000803f0000c03f0000f0410203050100000002000f00000078000000000f000001010d000204060a496e6e657273726f7468030002040800030002041100030002040900030002040a00160002021e1100000a496e6e657273726f7468000000000000"
        let packet = try XCTUnwrap(Data(hex: raw))

        let auPacket = try XCTUnwrap(PacketParser.parse(packet: packet))
        guard case .reliable(let reliable) = auPacket else {
            XCTFail()
            return
        }
        XCTAssertEqual(reliable.messages.count, 1)

        guard case .gameData(let gameData) = reliable.messages[0].payload else {
            XCTFail()
            return
        }

        XCTAssertEqual(gameData.messages.count, 10)
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
        ("testReadPackedUInt32", testReadPackedUInt32),
        ("testParseRedirect", testParseRedirect),
        ("testParseRedirect", testParseRedirect),
        ("testParseGameData", testParseGameData),
        ("testParseHelloPacket", testParseHelloPacket),
        ("testParseDisconnectPacket", testParseDisconnectPacket),
    ]
}
