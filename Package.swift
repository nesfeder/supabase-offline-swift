// swift-tools-version: 6.0
// Copyright (c) 2026 nesfeder
// SPDX-License-Identifier: MIT
import PackageDescription

/// The release whose framework archive the package is built on; the release sets it.
let version = "0.1.0"

/// The SHA-256 checksum of that archive; the release sets it with `version`.
let checksum = "a13b748c379f2098b171c352d33e6194638ea50283d41c0c102fe6f80ac8a51b"

/// Swift 6, and imports internal unless a file says otherwise, so no public signature can name a
/// type of the framework underneath.
let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableUpcomingFeature("InternalImportsByDefault"),
]

let package = Package(
    name: "SupabaseOffline",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SupabaseOffline", targets: ["SupabaseOffline"]),
        .library(name: "SupabaseOfflineTesting", targets: ["SupabaseOfflineTesting"]),
    ],
    targets: [
        .binaryTarget(
            name: "SupabaseOfflineCore",
            url: "https://github.com/nesfeder/supabase-offline-kt/releases/download/\(version)/SupabaseOfflineCore.xcframework.zip",
            checksum: checksum
        ),
        .target(
            name: "SupabaseOffline",
            dependencies: ["SupabaseOfflineCore"],
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: swiftSettings,
            // The framework is static: Apple's SQLite and the C++ runtime come from the app's link.
            linkerSettings: [.linkedLibrary("sqlite3"), .linkedLibrary("c++")]
        ),
        .target(
            name: "SupabaseOfflineTesting",
            dependencies: ["SupabaseOffline", "SupabaseOfflineCore"],
            swiftSettings: swiftSettings
        ),
    ]
)
