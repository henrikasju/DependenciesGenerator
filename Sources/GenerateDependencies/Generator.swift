import Foundation

@main
struct Generator {
    enum Failure: Error {
        case unableToReadResolvedPackagesFile
        case unableToGetDataFromResolvedPackagesFile
        case unableToDecodeResolvedPackagesFile
        
        case unableToWriteToOutputPath
    }
    
    static func main () throws {
        let arguments = ProcessInfo().arguments
        let (resolvedPackagesFilePath, outputPath) = (arguments[1], arguments[2])
        log("resolvedPackagesFilePath: \(resolvedPackagesFilePath), outputPath: \(outputPath)")
        
        let resolvedDependencies = try resolvedDependencies(at: resolvedPackagesFilePath)
        let generatedFileContent = StructureGenerator.content(from: resolvedDependencies)
        try write(generatedFileContent, to: outputPath)
    }
    
    private static func resolvedDependencies(at filePath: String) throws -> ResolvedDependencies {
        let content: String
        do {
            content = try String(contentsOfFile: filePath)
        } catch {
            log("Unable to read resolved packages file: \(filePath), error: \(error)")
            throw Failure.unableToReadResolvedPackagesFile
        }
        guard let data = content.data(using: .utf8) else {
            throw Failure.unableToGetDataFromResolvedPackagesFile
        }
        do {
            return try JSONDecoder().decode(ResolvedDependencies.self, from: data)
        } catch {
            log("Unable to decode resolved packages file: \(filePath), error: \(error)")
            throw Failure.unableToReadResolvedPackagesFile
        }
    }
    
    private static func write(_ content: String, to filePath: String) throws {
        do {
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            log("Unable to write to output path: \(filePath), error: \(error)")
            throw Failure.unableToWriteToOutputPath
        }
    }

    private static func log(_ message: String) {
        debugPrint("\(self) - \(message)")
    }
}
