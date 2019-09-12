//
//  NSCopying.swift
//  
//
//  Created by Braden Scothern on 9/11/19.
//

#if canImport(Foundation)
import Foundation

// Provides a default implimentation of `createCopy(of:)` for `NSCopying` objects.
extension Copyable where Self: NSCopying {
    static func createCopy(of instance: Self) -> Self {
        instance.copy() as! Self
    }
}

#endif
