// swift-tools-version:5.1

import PackageDescription

let package = Package(
	name: "MultilineTextField",
	platforms: [
		.iOS(.v13),
		.tvOS(.v13)
	],
	products: [
		.library(
			name: "MultilineTextField",
			targets: ["MultilineTextField"]
		)
	],
	targets: [
		.target(name: "MultilineTextField"),
		.testTarget(
			name: "MultilineTextFieldTests",
			dependencies: ["MultilineTextField"]
		)
	]
)
