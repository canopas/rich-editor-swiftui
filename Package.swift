// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RichEditorSwiftUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v17),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "RichEditorSwiftUI",
            targets: ["RichEditorSwiftUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RichEditorSwiftUI",
            dependencies: [],
            resources: [],
            swiftSettings: [
                .define("macOS", .when(platforms: [.macOS])),
                .define("iOS", .when(platforms: [.iOS, .macCatalyst]))
            ]
        ),
        .testTarget(
            name: "RichEditorSwiftUITests",
            dependencies: ["RichEditorSwiftUI"],
            swiftSettings: [
                .define("macOS", .when(platforms: [.macOS])),
                .define("iOS", .when(platforms: [.iOS, .macCatalyst]))
            ]
        )
    ]
)
