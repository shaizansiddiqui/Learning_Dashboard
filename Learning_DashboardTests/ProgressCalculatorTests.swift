import XCTest
@testable import Learning_Dashboard

final class ProgressCalculatorTests: XCTestCase {
    func testProgressPercentages() {
        XCTAssertEqual(ProgressCalculator.calculateProgress(completedLessons: 2, totalLessons: 4), 50)
        XCTAssertEqual(ProgressCalculator.calculateProgress(completedLessons: 3, totalLessons: 4), 75)
        XCTAssertEqual(ProgressCalculator.calculateProgress(completedLessons: 4, totalLessons: 4), 100)
        XCTAssertEqual(ProgressCalculator.calculateProgress(completedLessons: 0, totalLessons: 4), 0)
    }

    func testZeroLessonsReturnsZero() {
        XCTAssertEqual(ProgressCalculator.calculateProgress(completedLessons: 0, totalLessons: 0), 0)
    }
}
