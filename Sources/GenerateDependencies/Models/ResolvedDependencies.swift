import Foundation

struct ResolvedDependencies: Decodable {
    // MARK: - Strcutures
    struct Dependency: Decodable {
        struct State: Decodable {
            enum VersioningType {
                case semantic(version: String, commit: String)
                case branch(name: String, commit: String)
                case commit(String)
            }
            
            // MARK: - Declarations
            let revision: String
            let branch: String?
            let version: String?
            
            var versioningType: VersioningType {
                switch (branch, version, revision) {
                case (.none, .some(let version), _): .semantic(version: version, commit: revision)
                case (.some(let name), _, _): .branch(name: name, commit: revision)
                case (.none, .none, _): .commit(revision)
                }
            }
        }
        
        // MARK: - Declarations
        let identity: String
        let location: String
        let state: State
    }
    
    enum CodingKeys: String, CodingKey {
        case dependencies = "pins"
    }
    
    // MARK: - Declarations
    let dependencies: [Dependency]
}
