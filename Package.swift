// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "PubNub",
    products: [
        .library(name: "PubNub", targets: ["PubNub"])
    ],
    targets: [
        .target(
            name: "PubNub",
            path: "Sources"
        )
    ]
)

