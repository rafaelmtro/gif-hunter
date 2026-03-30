// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GifHunter",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "GifHunter", targets: ["GifHunter"])
    ],
    dependencies: [
        .package(url: "https://github.com/TokamakUI/Tokamak", from: "0.11.0"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.18.0")
    ],
    targets: [
        .executableTarget(
            name: "GifHunter",
            dependencies: [
                .product(name: "TokamakShim", package: "Tokamak"),
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]
        ),
        .testTarget(
            name: "GifHunterTests",
            dependencies: ["GifHunter"]
        )
    ]
)
