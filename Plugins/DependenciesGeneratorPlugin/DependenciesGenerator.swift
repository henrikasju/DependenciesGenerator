import PackagePlugin
import XcodeProjectPlugin
import Foundation

@main
struct DependenciesGenerator: BuildToolPlugin, XcodeBuildToolPlugin {
    // MARK: - Methods
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        debugPrint("Build tool is not supported in plugin context!")
        return []
    }

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let projectName = context.xcodeProject.displayName
        let executablePath = try context.tool(named: "GenerateDependencies").path
        let resolvedPackagesPath = context.xcodeProject.directory.appending([
            "\(projectName).xcodeproj",
            "project.xcworkspace",
            "xcshareddata",
            "swiftpm",
            "Package.resolved",
        ])
        let generatedDependenciesPath = context.pluginWorkDirectory.appending(subpath: "ResolvedDependencies.swift")
        debugPrint("\(type(of: self)) - input: \(resolvedPackagesPath), output: \(generatedDependenciesPath)")
        return [
            .buildCommand(
                displayName: "Generating Xcode SPM dependencies",
                executable: executablePath,
                arguments: [
                    resolvedPackagesPath,
                    generatedDependenciesPath
                ],
                inputFiles: [resolvedPackagesPath],
                outputFiles: [generatedDependenciesPath]
            )
        ]
    }
}
