import Foundation

struct StructureGenerator {
    static func content(from resolvedDependencies: ResolvedDependencies) -> String {
        var generatedFileContent = """
        struct Resolved {
            // MARK: - Structures
            struct Dependency {
                enum VersioningType {
                    case semantic(version: String, commit: String)
                    case branch(name: String, commit: String)
                    case commit(String)
                }
                
                // MARK: - Declarations
                let id: String
                let source: String
                let versioningType: VersioningType
            }
        
            // MARK: - Declarations
            static let dependencies: [Dependency] = [
        
        """
        resolvedDependencies.dependencies.forEach { dependency in
            generatedFileContent.append(
            """
                    Dependency(
                        id: "\(dependency.identity)",
                        source: "\(dependency.location)",
                        versioningType: \(versioningType(from: dependency.state.versioningType))
                    ),
            
            """
            )
        }
        generatedFileContent.append(
        """
            ]
        }
        """
        )
        return generatedFileContent
    }
    
    private static func versioningType(from type: ResolvedDependencies.Dependency.State.VersioningType) -> String {
        switch type {
        case .semantic(let version, let commit):
            """
            .semantic(version: "\(version)", commit: "\(commit)")
            """
        case .branch(let name, let commit):
            """
            .branch(name: "\(name)", commit: "\(commit)")
            """
        case .commit(let string):
            """
            .commit("\(string)")"
            """
        }
    }
}
