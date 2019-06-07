//
//  Copyable.swift
//  
//
//  Created by Braden Scothern on 6/6/19.
//

/// An object that can be coppied.
public protocol Copyable: AnyObject {
    /// Creates a copy of `other`.
    ///
    /// - parameter other: The object that should be coppied.
    init(copying other: Self)
}
