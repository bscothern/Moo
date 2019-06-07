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

        $a = COW<NonFinalClass>(initialValue: NonFinalClass())
        $b = COW<NonFinalClass>(initialValue: NonFinalClass())
        b = a
    }

    func testIdentities() {
        XCTAssert($a._value === $b._value)
        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 0)
    }

    func testBasicCopy() {
        b.i = 1
        b.i = 2

        XCTAssertEqual($b._copyCount, 1)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 2)

        XCTAssertEqual($a._copyCount, 0)
        XCTAssertEqual($b._copyCount, 1)
    }

    func testOneCopyOnRead() {
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)
    }

    func testNoCopyIntoCopy() {
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 0)
        XCTAssertEqual($b._copyCount, 0)

        b.i = 1
        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 1)

        XCTAssertEqual($a._copyCount, 1)
        XCTAssertEqual($b._copyCount, 0)
    }

    func testManyCopies() {
        for i in 1...100 {
            b.i = 1
            XCTAssertEqual($a._copyCount, 0)
            XCTAssertEqual($b._copyCount, i)
            b.i = 2
            XCTAssertEqual($a._copyCount, 0)
            XCTAssertEqual($b._copyCount, i)
            b = a
        }
    }

    static var allTests = [
        ("testBasicCopy", testBasicCopy),
    ]
}
