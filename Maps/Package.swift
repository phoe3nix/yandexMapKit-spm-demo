// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Maps",
    products: [
        .library(
            name: "Maps",
            targets: ["Maps"]),
    ],
    dependencies: [
		.package(path: "../YandexMapsWrapper")
    ],
    targets: [
        .target(
            name: "Maps",
            dependencies: [
				"YandexMapsWrapper"
			]
		),
        .testTarget(
            name: "MapsTests",
            dependencies: ["Maps"]),
    ]
)
