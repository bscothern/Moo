//
//  Copyable.swift
//  
//
//  Created by Braden Scothern on 6/6/19.
//

/// An object that can be coppied.
///
/// - Note: Adding conformance to a type conforming to `Foundation.NSCopying` will get an implimentation of this protocol for free.
public protocol Copyable: _Copyable, AnyObject {
    /// Creates a copy of an instance of the `Copyable` type.
    ///
    /// - parameter instance: The object that should be coppied.
    /// - returns: A copy of `instance`.
    static func createCopy(of instance: Self) -> Self
}

/// A helper protocol to `Copyable` to help by-pass PAT restrictions when needed.
///
/// See the global function `_createCopy(of:)`
///
/// - Important: You shouldn't add your own conformances to this type.
public protocol _Copyable {
    
    /// A function that is used to access `Copyable` while avoiding PAT restrictions.
    ///
    /// - Important: The default implimentation of this assumes that `instance` is `Self`.
    ///
    /// - Parameter instance: The instance to create a copy of.
    ///     This should be of type `Self`.
    static func __createCopy(of instance: Any) -> Any
}

public extension _Copyable where Self: Copyable {
    static func __createCopy(of instance: Any) -> Any {
        Self.createCopy(of: instance as! Self)
    }
}

/// Attempts to create a copy of `instance`.
///
/// - Parameter instance: A value to attempt to copy.
/// - Returns: If `instance` is `Copyable` then a copy of it is created otherwise `nil`.
public func _createCopy<Value>(of instance: Value) -> Value? {
    (Value.self as? _Copyable.Type)?.__createCopy(of: instance) as? Value
}
