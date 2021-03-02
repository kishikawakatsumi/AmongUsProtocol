import Foundation

public struct ReselectServer: Equatable {
    public let version: UInt8
    public let masterServersLength: UInt32
    public let masterServers: [MasterServer]
}

extension ReselectServer: CustomStringConvertible {
    public var description: String {
        "{Version: \(version), Master Servers Length: \(masterServersLength), Master Servers: \(masterServers)}"
    }
}

public struct MasterServer: Equatable {
    public let length: UInt16
    public let tag: UInt8
    public let name: String
    public let ipAddress: String
    public let port: UInt16
    public let numberOfConnections: UInt32
}

extension MasterServer: CustomStringConvertible {
    public var description: String {
        "{Name: \(name), IP Address: \(ipAddress), Port: \(port), Number of Connections: \(numberOfConnections)}"
    }
}
