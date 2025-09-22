import ProjectDescription

let project = Project(
    name: "AeroPath",
    targets: [
        Target(
            name: "AeroPath",
            platform: .iOS,
            product: .app,
            bundleId: "com.delaem.aero-path",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1",
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSLocationWhenInUseUsageDescription": "AeroPath использует ваше местоположение для добавления городов на карту",
                "NSLocationAlwaysAndWhenInUseUsageDescription": "AeroPath использует ваше местоположение для добавления городов на карту"
            ]),
            sources: ["aero path/**/*.swift"],
            resources: ["aero path/**/*.xcassets"],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "YOUR_TEAM_ID",
                    "CODE_SIGN_STYLE": "Automatic",
                    "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
                    "TARGETED_DEVICE_FAMILY": "1",
                    "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
                    "SUPPORTS_MACCATALYST": "NO",
                    "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO"
                ]
            )
        )
    ],
    schemes: [
        Scheme(
            name: "AeroPath",
            shared: true,
            buildAction: .buildAction(targets: ["AeroPath"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
