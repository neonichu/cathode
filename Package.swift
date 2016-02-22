import PackageDescription

let package = Package(
  name: "cathode",
  dependencies: [
    .Package(url: "https://github.com/neonichu/Chores.git", majorVersion: 0),
    .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 6),
    .Package(url: "https://github.com/neonichu/Decodable.git", majorVersion: 0),
    .Package(url: "https://github.com/neonichu/Version.git", majorVersion: 0, minor: 2),
  ]
)
