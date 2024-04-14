// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-snapshot-testing-vision",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SnapshotTestingVision",
            targets: ["VisionImageScan",
                      "SnapshotTestingVision"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.16.0"
        )
    ],
    targets: [
        .target(
            name: "SnapshotTestingVision",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                "VisionImageScan"
            ]),
        .target(
            name: "VisionImageScan"
        ),
        .testTarget(
            name: "VisionImageScanTests",
            dependencies: ["VisionImageScan",
                           .product(name: "SnapshotTesting", package: "swift-snapshot-testing")]),

        .testTarget(
            name: "SnapshotTestingVisionTests",
            dependencies: ["VisionImageScan",
                           "SnapshotTestingVision"]),
    ]
)