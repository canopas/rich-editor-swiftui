// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RichEditorSwiftUI",
    platforms: [
        //Add supported platforms here
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RichEditorSwiftUI",
            targets: ["RichEditorSwiftUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a pack.age, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RichEditorSwiftUI"),
        .testTarget(
            name: "RichEditorSwiftUITests",
            dependencies: ["RichEditorSwiftUI"]),
    ]
)
