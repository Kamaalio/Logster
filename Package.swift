// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logster",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "Logster",
            targets: ["Logster"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Logster",
            dependencies: []
        ),
        .testTarget(
            name: "LogsterTests",
            dependencies: ["Logster"]
        ),
    ]
)
