// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IapPurchasePlugin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "IapPurchasePlugin",
            targets: ["IapPurchasePluginPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "IapPurchasePluginPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/IapPurchasePluginPlugin"),
        .testTarget(
            name: "IapPurchasePluginPluginTests",
            dependencies: ["IapPurchasePluginPlugin"],
            path: "ios/Tests/IapPurchasePluginPluginTests")
    ]
)