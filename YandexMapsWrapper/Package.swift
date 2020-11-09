// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YandexMapsWrapper",
    products: [
        .library(
            name: "YandexMapsWrapper",
            targets: ["YandexMaps"]),
    ],
    dependencies: [
    ],
    targets: [
		.binaryTarget(
			name: "YandexMapKit",
			url: "ссылка до файла",
			checksum: "394fb7b25d54e006e153d82be37b746f7095b27fe8d5707fc3dc817e4eb05440"
		),
		.binaryTarget(
			name: "YandexRuntime",
			url: "ссылка до файла",
			checksum: "8e39a318448d9b39d17df37893162f42ae512c2939d44c85d46ff24b447eb608"
		),
		.target(
			name: "YandexMaps",
			dependencies: [
				"YandexMapsLibraries"
			]
		),
		.target(
			name: "YandexMapsLibraries",
			dependencies: [
				"YandexMapKit",
				"YandexRuntime",
			]
		),
    ]
)
