// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "{{ libName }}",
  platforms: [.iOS(.v9)],
  products: [
    .library(name: "{{ libName }}", targets: ["{{ libName }}"]),
  ],
  targets: [
    .target(name: "{{ libName }}", dependencies: [], path: "Sources")
  ]
)
