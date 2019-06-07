# Moo 🐮

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/bscothern/Moo/blob/master/LICENSE.txt) [![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A package to give reference types Copy On Write (COW) symantics.

### ** Requires Xcode11 and Swift 5.1 **

## Swift Package Manager
Update your `Package.swift` to include this to your package dependencies:
```
.package(url: "https://github.com/bscothern/Moo.git", from: "0.2.0")
```

## Usage
Moo works with types that conform to the `Copyable` protocol. You should make a class conform like this

```
import Moo

final class SomeType: Copyable {
    static func createCopy(of other: SomeType) -> SomeType { ... }
    ...
}
```
You will likely want to have your class be `final` in order to return a the concrete type rather than `Self` which is what the protocol requires. This avoids the need to use `SomeNonFinalType(...) as! SomeNonFinalType` as the return value and a lot of potential bugs that can come with inheritance.

Once a type is `Copyable` you simply applie the `@COW` property wrapper to the type and it will be coppied when you access the wrapped value.

```
struct SomeOtherType {
    @COW someType: SomeType = SomeType(...)
}
```

**IMPORTANT:** Until Swift exposes the `_modify` accessor as a public access modifier the copy will happen on any read or write where the wrapped type doesn't have a unique referenece.

## Acknowledgements
Thanks to:

* airspeedswift's [cowed](https://gist.github.com/airspeedswift/71ccddc27354be908dd92a52a34a776f)
* Doug Gregor's property wrappers proposal [example](https://github.com/DougGregor/swift-evolution/blob/property-wrappers/proposals/0258-property-wrappers.md#copy-on-write)
