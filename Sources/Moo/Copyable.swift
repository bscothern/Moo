//
//  Copyable.swift
//  
//
//  Created by Braden Scothern on 6/6/19.
//

/// An object that can be coppied.
public protocol Copyable: _Copyable, AnyObject {
    /// Creates a copy of an instance of the `Copyable` type.
    ///
    /// - parameter instance: The object that should be coppied.
    /// - returns: A copy of `other`.
    static func createCopy(of instance: Self) -> Self
}

public protocol _Copyable {
    static func __createCopy(of instance: Any) -> Any
}

public extension _Copyable where Self: Copyable {
    static func __createCopy(of instance: Any) -> Any {
        return instance
    }
}

public func _createCopy<Value>(of instance: Value) -> Value? {
    (Value.self as? _Copyable.Type)?.__createCopy(of: instance) as? Value
}
