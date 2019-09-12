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

        _COWCopyCount = 0

        _a = COW<SomeClass>(wrappedValue: SomeClass())
    }

    func testDirectPass() {
        XCTAssertEqual(_a._copyCount, 0)

        func direct(_ value: SomeClass) {
            value.i += 1
        }
        direct(a)
        XCTAssertEqual(_a._copyCount, 0)

        XCTAssertEqual(a.i, 1)
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 0)
    }

    func testCOWPass() {
        XCTAssertEqual(_a._copyCount, 0)

        func cowPass(_ value: COW<SomeClass>) {
            let i = value.i + 1
            XCTAssertEqual(_COWCopyCount, 0)
            var value = value
            value.i += 1
            XCTAssertEqual(i, value.i)
        }
        cowPass(_a)

        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 1)
    }

    func testInoutCOWPass() {
        XCTAssertEqual(_a._copyCount, 0)

        func inoutCOWPass(_ value: inout COW<SomeClass>) {
            value.i += 1
        }
        inoutCOWPass(&_a)

        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(a.i, 1)
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 0)
    }
}
