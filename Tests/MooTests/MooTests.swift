@testable import Moo
import XCTest

final class MooTests: XCTestCase {
    final class A: Copyable {
        var i: Int

        init(i: Int = 0) {
            self.i = i
        }

        func copy() -> A {
            return A(i: i)
        }
    }

    @COW var a = A()
    @COW var b = A()

    func testExample() {
        b = a
        b.i = 1
        b.i = 2

        XCTAssertEqual($b.copyCount, 1)
        XCTAssertEqual(a.i, 0)
        XCTAssertEqual(b.i, 2)
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
