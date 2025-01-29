// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Charty",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Charty",
            targets: ["Charty"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChartsOrg/Charts.git", from: "5.1.0")
    ],
    targets: [
        .target(
            name: "Charty",
            dependencies: [
                .product(name: "DGCharts", package: "Charts")
            ]),
        .testTarget(
            name: "ChartyTests",
            dependencies: ["Charty"]),
    ]
)
