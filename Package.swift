// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DependenciesGenerator",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .plugin(
            name: "DependenciesGeneratorPlugin",
            targets: ["DependenciesGeneratorPlugin"]),
    ],
    targets: [
        .executableTarget(
            name: "GenerateDependencies"
        ),
        .plugin(
            name: "DependenciesGeneratorPlugin",
            capability: .buildTool(),
            dependencies: ["GenerateDependencies"]
        ),
    ]
)
