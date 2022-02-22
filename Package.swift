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
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(url: "https://github.com/nerdsupremacist/syntax-highlight-publish-plugin.git", from: "0.1.0"),
        .package(url: "https://github.com/hejki/sasspublishplugin.git", from: "0.1.0"),
        .package(name: "SVGPublishPlugin", url: "https://github.com/c0dedbear/SVGPublishPlugin", from: "0.1.0"),
        .package(name: "MinifyCSSPublishPlugin", url: "https://github.com/labradon/minifycsspublishplugin", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "OddmagnetDev",
            dependencies: [
                "Publish",
                .product(name: "SyntaxHighlightPublishPlugin", package: "syntax-highlight-publish-plugin"),
                .product(name: "SassPublishPlugin", package: "sasspublishplugin"),
                "SVGPublishPlugin",
                "MinifyCSSPublishPlugin"
            ]
        )
    ]
)
