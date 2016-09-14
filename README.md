# cathode

[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

Cathode makes it easy to run Swift scripts, by utilizing [chswift][1] to choose
the right Swift version and the [Swift Package Manager][2] to install missing dependencies.

If you don't know what Swift scripts even are, check out [Ayaka's talk][3].

## Installation

```
$ brew tap neonichu/formulae
$ brew install cathode
```

## Usage

Cathode is supposed to be run via a script's [hash-bang][4] directive:

```swift
#!/usr/bin/env cathode

import Chores

let result = >["xcodebuild", "-version"]
print(result.stdout)
```

Any frameworks that do not ship with the system will be installed into their own
private directory under `$HOME/.🔋`, named after the script's basename.


[1]: https://github.com/neonichu/chswift
[2]: https://github.com/apple/swift-package-manager
[3]: https://speakerdeck.com/ayanonagon/swift-scripting
[4]: http://en.wikipedia.org/wiki/Shebang_(Unix)
