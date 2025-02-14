// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WarpShader",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
        // watchOS does not support `.colorEffect()`
    ],
    products: [
        .library(
            name: "WarpShader",
            targets: ["WarpShader"]),
        .executable(name: "WarpShaderExample", targets: ["WarpShaderExample"]),
    ],
    targets: [
        .target(
            name: "WarpShader",
            resources: [.process("Shaders.metal")]),
        .executableTarget(name: "WarpShaderExample", dependencies: [
            "WarpShader"
        ])
    ]
)
