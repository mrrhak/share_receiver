// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "share_receiver",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "share-receiver", targets: ["share_receiver"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "share_receiver",
            dependencies: [],
        )
    ]
)
