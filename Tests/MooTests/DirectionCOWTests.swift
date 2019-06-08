//
//  DirectionCOWTests.swift
//  
//
//  Created by Braden Scothern on 6/7/19.
//

@testable import Moo
import XCTest

final class SomeClass: Copyable {
    var i: Int
    
    init(i: Int = 0) {
        self.i = i
    }
    
    static func createCopy(of other: SomeClass) -> SomeClass {
        return SomeClass(i: other.i)
    }
}

final class DirectionCOWTests: XCTestCase {
    @COW private var a = SomeClass()
    
    override func setUp() {
        super.setUp()
        
        _globalCOWCopyCount = 0
        
        $a = COW<SomeClass>(initialValue: SomeClass())
    }
    
    func testDirectPass() {
        XCTAssertEqual($a._copyCount, 0)
        
        func direct(_ value: SomeClass) {
            value.i += 1
        }
        direct(a)
        XCTAssertEqual($a._copyCount, 0)
        
        XCTAssertEqual(a.i, 1)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 0)
    }

    func testCOWPass() {
        XCTAssertEqual($a._copyCount, 0)
        
        func cowPass(_ value: COW<SomeClass>) {
            let i = value.i + 1
            XCTAssertEqual(_globalCOWCopyCount, 0)
            var value = value
            value.i += 1
            XCTAssertEqual(i, value.i)
        }
        cowPass($a)

        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 1)
    }
    
    func testInoutCOWPass() {
        XCTAssertEqual($a._copyCount, 0)
        
        func inoutCOWPass(_ value: inout COW<SomeClass>) {
            value.i += 1
        }
        inoutCOWPass(&$a)
        
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual(a.i, 1)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 0)
    }
}
