//
//  COW.swift
//
//
//  Created by Braden Scothern on 6/6/19.
//

/// A `@propertyWrapper` that gives reference types Copy-On-Write symantics.
@propertyWrapper
@dynamicMemberLookup
public struct COW<Value: Copyable> {
    // MARK: - Properties

    /// The reference to object that the `COW` gives Copy-On-Write symantics to.
    ///
    /// - Note: This is internal so it can be inspected in tests
    internal var value: Value

    #if DEBUG
    /// A counter used for debugging and testing to check how often copies are made.
    internal var _copyCount: Int = 0
    #endif

    /// The value vended by the `@propertyWrapper`.
    public var wrappedValue: Value {
        mutating get {
            makeValueUniqueIfNeeded()
            return value
        }
        mutating set { value = newValue }
        _modify {
            makeValueUniqueIfNeeded()
            yield &value
        }
    }

    /// Creates a `COW`.
    ///
    /// This `init` is part of the requirements of `@propertyWrapper`.
    ///
    /// - Parameter wrappedValue: The initial value contained in the `COW`.
    public init(wrappedValue: Value) {
        value = wrappedValue
    }

    // MARK: dynamicMemberLookup
    public subscript<Result>(dynamicMember keypath: KeyPath<Value, Result>) -> Result {
        value[keyPath: keypath]
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Result {
        mutating get { wrappedValue[keyPath: keyPath] }
        mutating set { wrappedValue[keyPath: keyPath] = newValue }
        _modify { yield &wrappedValue[keyPath: keyPath] }
    }

    // MARK: - Funcs
    // MARK: Private

    /// Creates a copy of `value` if it has multiple references.
    private mutating func makeValueUniqueIfNeeded() {
        guard !isKnownUniquelyReferenced(&value) else {
            return
        }
        value = Value.createCopy(of: value)

        #if DEBUG
        _copyCount += 1
        _COWCopyCount += 1
        #endif
    }
}

#if DEBUG
/// A global counter of how many copys have taken place.
///
/// This only exists for testing purposes
internal var _COWCopyCount: Int = 0
#endif
