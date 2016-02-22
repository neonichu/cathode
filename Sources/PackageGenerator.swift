import Chores
import Foundation
import PathKit

extension String {
  private func split(char: Character) -> [String] {
    return self.characters.split { $0 == char }.map(String.init)
  }

  var lines: [String] {
    return split("\n")
  }

  var words: [String] {
    return split(" ")
  }
}

func currentSDK() -> Path {
	let result = >["xcrun", "--sdk", "macosx", "--show-sdk-platform-path"]
	let platform = Path(result.stdout)
	let sdks = try? (platform + "Developer/SDKs").children()
	return sdks?.first ?? Path.current
}

func frameworksPath() -> Path {
	let result = >["xcrun", "--show-sdk-path"]
	let sdkPath = Path(result.stdout)
	return (sdkPath + "../../Library/Frameworks").normalize()
}

func systemFrameworks() -> [String] {
	let systemFrameworksPath = currentSDK() + "System/Library/Frameworks"
	var frameworks = (try? systemFrameworksPath.children()) ?? [Path]()

	if let moarFrameworks = try? frameworksPath().children() {
		frameworks += moarFrameworks
	}

	return frameworks.map { $0.lastComponentWithoutExtension }
}

func generatePackage(path: Path, _ packages: [Package]) -> String {
	var packageMap = [String:Package]()
	packages.forEach {
		packageMap[$0.name] = $0
	}

	guard let fileContents = try? NSString(contentsOfFile: path.description, usedEncoding: nil) else { return "" }
	let frameworksToFilter = systemFrameworks()
	let frameworks = (fileContents as String).lines.filter { $0.hasPrefix("import") }
		.flatMap { $0.words.last }
		.filter { !frameworksToFilter.contains($0) }
	let dependencies = frameworks.flatMap { packageMap[$0]?.asDependency() }

	return "import PackageDescription\n\n" +
		"_ = Package(dependencies: [\n" + dependencies.joinWithSeparator(",\n") + 
		"\n])"
}
