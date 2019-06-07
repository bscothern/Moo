// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Moo",
    products: [
        .library(
            name: "Moo",
            targets: ["Moo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Moo",
            dependencies: []),
        .testTarget(
            name: "MooTests",
            dependencies: ["Moo"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
