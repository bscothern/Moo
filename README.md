# Moo 🐮

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/bscothern/Moo/blob/master/LICENSE.txt) [![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A package to give reference types Copy on Write symantics.

## Usage
Moo works with types that conform to the `Copyable` protocol. You should make a class conform like this

```
import Moo

class SomeType: Copyable {
	required init(copying other: SomeType) {
		// Copy other to create self
	}
	...
}
```

## Swift Package Manager
Update your `Package.swift` to include this to your package dependencies:
```
.package(url: "https://github.com/bscothern/Moo.git", from: "1.0.0")
```
