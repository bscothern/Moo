@testable import Moo
import XCTest

private final class FinalClass: Copyable {
    var i: Int

    init(i: Int = 0) {
        self.i = i
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

        $a = COW<FinalClass>(initialValue: FinalClass())
        $b = COW<FinalClass>(initialValue: FinalClass())
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
