// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CPU6502Core",
    products: [
        .library(
            name: "CPU6502Core",
            targets: ["CPU6502Core"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CPU6502Core",
            dependencies: []),
        .testTarget(
            name: "CPU6502CoreTests",
            dependencies: ["CPU6502Core"]),
    ]
)
