// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swiftui-flow-layout",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "FlowLayout",
            targets: ["FlowLayout"]
        )
    ],
    targets: [
        .target(
            name: "FlowLayout",
            dependencies: [],
            path: "Sources/FlowLayout"
        ),
        .testTarget(
            name: "FlowLayoutTests",
            dependencies: ["FlowLayout"],
            path: "Tests/FlowLayoutTests"
        )
    ]
)
