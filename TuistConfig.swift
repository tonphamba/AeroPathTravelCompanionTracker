import ProjectDescription

let config = Config(
    compatibleXcodeVersions: ["15.0", "15.1", "15.2", "15.3", "15.4"],
    cloud: nil,
    cache: .cache(path: .relativeToRoot("Cache")),
    generationOptions: .options(
        resolveDependenciesWithSystemScm: false,
        disablePackageVersionLocking: false
    )
)
