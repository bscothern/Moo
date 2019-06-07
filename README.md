# Moo 🐮

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/bscothern/Moo/blob/master/LICENSE.txt) [![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A package to give reference types Copy On Write (COW) symantics.


## Swift Package Manager
Update your `Package.swift` to include this to your package dependencies:
```
.package(url: "https://github.com/bscothern/Moo.git", from: "1.0.0")
```

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

Once a type is `Copyable` you simply applie the `@COW` property wrapper to the type and it will be coppied when you access the wrapped value.

```
struct SomeOtherType {
    @COW someType: SomeType = SomeType(...)
}
```

**IMPORTANT:** Until Swift exposes the `_modify` accessor as a public access modifier the copy will happen on any read where the wrapped type doesn't have a unique referenece.

## Acknowledgements
Thanks to: airspeedswift's [cowed](https://gist.github.com/airspeedswift/71ccddc27354be908dd92a52a34a776f) and the Property Wrappers proposal [example](https://github.com/DougGregor/swift-evolution/blob/property-wrappers/proposals/0258-property-wrappers.md#copy-on-write)
