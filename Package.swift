// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AiolaSwiftSDK",
    platforms: [
            .macOS(.v10_15), .iOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AiolaSwiftSDK",
            targets: ["AiolaSwiftSDK"]),
    ],
    dependencies: [
            .package(url: "https://github.com/socketio/socket.io-client-swift", from: "16.0.1") // Socket.IO for streaming
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AiolaSwiftSDK",
            dependencies: [
                            .product(name: "SocketIO", package: "socket.io-client-swift")
                        ]),
        .testTarget(
            name: "AiolaSwiftSDKTests",
            dependencies: ["AiolaSwiftSDK"]),
    ]
)
