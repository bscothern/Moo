# Moo 🐮

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/bscothern/Moo/blob/master/LICENSE.txt) [![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![Build Status](https://travis-ci.org/bscothern/Moo.svg?branch=master)](https://travis-ci.org/bscothern/Moo)

A package to give reference types Copy On Write (COW) symantics using Property Wrappers and no external dependencies.

## Swift Package Manager
Update your `Package.swift` to include this to your package dependencies:
```
.package(url: "https://github.com/bscothern/Moo.git", from: "1.1.0")
```

## Usage
### General
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

### Working with NSCopying
If you have a type that conforms to `NSCopying` you can conform it to `Copyable` and it will use `NSCopying`'s `copy()` function as the default implimentation of `Copyable`'s requirements.

### Bypassing Self Requirements
Because `Copyable` has `Self` requirements it can cause issues if you try to have a collection of them. If you need to create a copy of a type you can also drop into `_createCopy(of:)` which is a function at global scope. It will safely attempt to use the `Copyable` protocol on the object and return a copy or `nil`.

## Acknowledgements
Thanks to:

* Ben Cohen's [cowed](https://gist.github.com/airspeedswift/71ccddc27354be908dd92a52a34a776f)
* Doug Gregor's property wrappers proposal [COW example](https://github.com/DougGregor/swift-evolution/blob/property-wrappers/proposals/0258-property-wrappers.md#copy-on-write)
