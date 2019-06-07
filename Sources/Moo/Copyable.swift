//
//  Copyable.swift
//  
//
//  Created by Braden Scothern on 6/6/19.
//

/// An object that can be coppied.
public protocol Copyable: AnyObject {
    /// Creates a copy of an instance of the `Copyable` type.
    ///
    /// - parameter other: The object that should be coppied.
    /// - returns: A copy of `other`.
    static func createCopy(of other: Self) -> Self
}
