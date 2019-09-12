//
//  FinalClassTests.swift
//
//
//  Created by Braden Scothern on 6/6/19.
//

@testable import Moo
import XCTest

private final class FinalClass: Copyable {
    struct S {
        var i: Int = 0
    }

    var i: Int
    var s: S

    init(i: Int = 0) {
        self.i = i
        s = S()
    }

    static func createCopy(of other: FinalClass) -> FinalClass {
        return FinalClass(i: other.i)
    }
}

final class FinalClassTests: XCTestCase {
    @COW private var a = FinalClass()
    @COW private var b = FinalClass()

    override func setUp() {
        super.setUp()

        _COWCopyCount = 0

        _a = COW<FinalClass>(wrappedValue: FinalClass())
        _b = COW<FinalClass>(wrappedValue: FinalClass())
        b = a
    }

    func testIdentities() {
        XCTAssert(_a.value === _b.value)
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 0)
    }

    func testBasicCopy() {
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 0)

        b.i = 1
        b.i = 2

        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 1)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 2)
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 1)
        XCTAssertEqual(_COWCopyCount, 1)
    }

    func testOneCopyOnRead() {
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual(_a._copyCount, 1)
        XCTAssertEqual(_b._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 1)
    }

    func testNoCopyIntoCopy() {
        XCTAssertEqual(_a._copyCount, 0)
        XCTAssertEqual(_b._copyCount, 0)

        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual(_a._copyCount, 1)
        XCTAssertEqual(_b._copyCount, 0)

        b.i = 1

        XCTAssertEqual(_a._copyCount, 1)
        XCTAssertEqual(_b._copyCount, 0)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 1)
        XCTAssertEqual(_a._copyCount, 1)
        XCTAssertEqual(_b._copyCount, 0)
        XCTAssertEqual(_COWCopyCount, 1)
    }

    func testManyCopies() {
        let iterations = 1...100
        for i in iterations {
            b.i += 1
            XCTAssertEqual(_a._copyCount, 0)
            XCTAssertEqual(_b._copyCount, i)
            b.i = 2
            XCTAssertEqual(_a._copyCount, 0)
            XCTAssertEqual(_b._copyCount, i)
            b = a
        }
        XCTAssertEqual(_COWCopyCount, iterations.count)
    }
}
