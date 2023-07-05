// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TTSegmentedControl",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "TTSegmentedControl",
            targets: ["TTSegmentedControl"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TTSegmentedControl",
            dependencies: []),
        .testTarget(
            name: "TTSegmentedControlTests",
            dependencies: ["TTSegmentedControl"]),
    ]
)
