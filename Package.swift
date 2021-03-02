// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AmongUsProtocol",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AmongUsProtocol",
            targets: ["AmongUsProtocol"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AmongUsProtocol",
            dependencies: []
        ),
        .testTarget(
            name: "AmongUsProtocolTests",
            dependencies: ["AmongUsProtocol"]
        ),
    ]
)
