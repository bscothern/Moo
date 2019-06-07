//
//  COW.swift
//
//
//  Created by Braden Scothern on 6/6/19.
//

/// A Property Delegate that gives reference types Copy-On-Write symantics.
@propertyDelegate
@dynamicMemberLookup
public struct COW<Value: Copyable> {
    /// The reference to object that the `COW` gives Copy-On-Write symantics to.
    ///
    /// - Note: This is internal so it can be inspected in tests
    internal var _value: Value

    #if DEBUG
    /// A counter used for debugging and testing to check how often copies are made.
    var _copyCount: Int = 0
    #endif

    // MARK: propertyDelegate
    public var value: Value {
        mutating get {
            if !isKnownUniquelyReferenced(&_value) {
                _value = Value.createCopy(of: _value)
                #if DEBUG
                _copyCount += 1
                #endif
            }
            return _value
        }
        mutating set {
            _value = newValue
        }
    }

    public init(initialValue: Value) {
        _value = initialValue
    }

    // MARK: dynamicMemberLookup
    public subscript<Result>(dynamicMember keypath: KeyPath<Value, Result>) -> Result {
        _value[keyPath: keypath]
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Result {
        mutating get { value[keyPath: keyPath] }
        mutating set { value[keyPath: keyPath] = newValue }
    }
}
