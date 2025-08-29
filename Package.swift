// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SwiftVectors",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(name: "SwiftVectors", targets: ["SwiftVectors"])
    ],
    targets: [
        .target(
            name: "SwiftVectors",
            path: "SwiftVectors"
        ),
        .testTarget(
            name: "SwiftVectorsTests",
            dependencies: ["SwiftVectors"],
            path: "SwiftVectorsTests"
        )
    ]
)
