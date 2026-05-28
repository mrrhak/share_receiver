// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "share_receiver",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // Main plugin target — links Flutter, use in the app target only
        .library(name: "share-receiver", targets: ["share_receiver"]),
        // Lightweight target — no Flutter, safe to use in a Share Extension
        .library(name: "share-receiver-models", targets: ["share_receiver_models"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "share_receiver",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/share_receiver",
            exclude: ["Models"]
        ),
        .target(
            name: "share_receiver_models",
            dependencies: [],
            path: "Sources/share_receiver/Models"
        ),
    ]
)
