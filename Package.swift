// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "Sheet Stack",
	platforms: [
		.macOS(.v11),
		.iOS(.v14)
	],
	products: [
		.library(
			name: "SheetStack",
			targets: [
				"SheetStack"
			]
		)
	],
	targets: [
		.target(
			name: "SheetStack"
		)
	]
)
