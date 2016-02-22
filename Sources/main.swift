import AppKit
import Chores
import PathKit

let args = Process.arguments

if args.count < 2 {
	print("Usage: \(args.first!) SWIFT-FILE")
	exit(1)
}

let filePath = Path(args.last!)
let basename = filePath.lastComponent

let run = { (packages: [Package]) throws in
	let moduleName = "_\(basename)" // FIXME: Create proper C99 identifier
	let packageDirectory = Path.home + ".🔋" + moduleName

	let sourcesPath = packageDirectory + "Sources"
	try sourcesPath.mkpath()

	let mainSwiftPath = sourcesPath + "main.swift"
	_ = try? mainSwiftPath.delete()
	try filePath.copy(mainSwiftPath)

	let manifest = generatePackage(filePath, packages)
	try manifest.writeToFile((packageDirectory + "Package.swift").description, atomically: true, encoding: NSUTF8StringEncoding)
	
	var buildCommand = ["swift", "build", "--configuration", "release"]

	var result = >["which", "chswift"]
	if result.result == 0 {
		// TODO: Make Swift version selectable
		buildCommand = ["chswift-exec", "2.2"] + buildCommand
	}

	packageDirectory.chdir {
		result = >buildCommand
		if result.result != 0 {
			print(result.stderr)
			exit(1)
		}

		result = >[".build/release/\(moduleName)"]
		print(result.stdout)
		exit(result.result)
	}
}

NSApplicationLoad()

fetchPackages {
	do {
		try run($0)
		exit(0)
	} catch let error {
		print(error)
		exit(1)
	}
}

NSApp.run()
