import Foundation
import Decodable
import Version

let PKG_CATALOGUE_URL = "https://swiftpkgs.ng.bluemix.net/api/packages?items=1000"

struct Package {
	let name: String
	let version: Version
	let packageId: Int
	let gitUrl: NSURL

	func asDependency() -> String {
		let minor = version.minor ?? 0
		return ".Package(url: \"\(gitUrl)\", majorVersion: \(version.major), minor: \(minor))"
	}
}

extension Package : Decodable {
	static func decode(json: AnyObject) throws -> Package {
		let gitUrlString: String = try json => "git_clone_url"
		let versionString: String? = try? json => "latest_version"

		return Package(
			name: try json => "package_name",
			version: versionString != nil ? Version(versionString!) : Version(major: 0),
			packageId: try json => "package_id",
			gitUrl: NSURL(string: gitUrlString)!
		)
	}
}

func fetchPackages(completion: [Package] -> Void) -> NSURLSessionDataTask? {
	let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
	let session = NSURLSession(configuration: sessionConfiguration)
	guard let url = NSURL(string: PKG_CATALOGUE_URL) else { fatalError("No URL") }
	let task = session.dataTaskWithURL(url) { data, response, error in
		guard let data = data else { fatalError("No data: \(error)") }
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
			let packages: [Package] = try json => "data"
			completion(packages)
		} catch let error {
			print(error)
			fatalError()
		}
	}
	task.resume()
	return task
}
