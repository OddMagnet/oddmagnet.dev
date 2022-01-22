// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "OddmagnetDev",
    products: [
        .executable(
            name: "OddmagnetDev",
            targets: ["OddmagnetDev"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "OddmagnetDev",
            dependencies: ["Publish"]
        )
    ]
)