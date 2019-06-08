//
//  NonFinalClassTests.swift
//
//
//  Created by Braden Scothern on 6/6/19.
//

@testable import Moo
import XCTest

private class NonFinalClass: Copyable {
    var i: Int

    init(i: Int = 0) {
        self.i = i
    }

    static func createCopy(of other: NonFinalClass) -> Self {
        return NonFinalClass(i: other.i) as! Self
    }
}

final class NonFinalClassTests: XCTestCase {
    @COW private var a = NonFinalClass()
    @COW private var b = NonFinalClass()

    override func setUp() {
        super.setUp()
        
        _globalCOWCopyCount = 0
        
        $a = COW<NonFinalClass>(initialValue: NonFinalClass())
        $b = COW<NonFinalClass>(initialValue: NonFinalClass())
        b = a
    }

    func testIdentities() {
        XCTAssert($a._value === $b._value)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 0)
    }

    func testBasicCopy() {
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 0)
        
        b.i = 1
        b.i = 2

        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 1)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 2)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 1)
        XCTAssertEqual(_globalCOWCopyCount, 1)
    }

    func testOneCopyOnRead() {
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 1)
    }

    func testNoCopyIntoCopy() {
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)

        b.i = 1
        
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 1)
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)
        XCTAssertEqual(_globalCOWCopyCount, 1)
    }

    func testManyCopies() {
        let iterations = 1...100
        for i in iterations {
            b.i += 1
            XCTAssertEqual($a._copyCount, 0)
            XCTAssertEqual($b._copyCount, i)
            b.i = 2
            XCTAssertEqual($a._copyCount, 0)
            XCTAssertEqual($b._copyCount, i)
            b = a
        }
        XCTAssertEqual(_globalCOWCopyCount, iterations.count)
    }
}
