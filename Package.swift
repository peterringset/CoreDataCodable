// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataCodable",
    platforms: [.iOS(.v10),
                .macOS(.v10_12)],
    products: [
        .library(
            name: "CoreDataCodable",
            targets: ["CoreDataCodable"]),
    ],
    targets: [
        .target(
            name: "CoreDataCodable",
            dependencies: [],
            exclude: ["Info.plist"]),
        .testTarget(
            name: "CoreDataCodableTests",
            dependencies: ["CoreDataCodable"],
            exclude: ["Info.plist"]),
    ]
)
