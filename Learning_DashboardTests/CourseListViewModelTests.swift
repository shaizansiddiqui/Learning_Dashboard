import XCTest
@testable import Learning_Dashboard

@MainActor
final class CourseListViewModelTests: XCTestCase {
    func testSuccessfulResponsePublishesCourses() async {
        let course = Course(id: 1, title: "Swift", instructor: "Alex", lessons: [Lesson(id: 1, title: "Basics", isCompleted: true)])
        let viewModel = CourseListViewModel(repository: StubRepository(result: CourseFetchResult(courses: [course], isFromCache: false)))
        let expectation = expectation(description: "loaded state")
        viewModel.onStateChange = { state in
            if case .loaded(let courses, _) = state { XCTAssertEqual(courses, [course]); expectation.fulfill() }
        }
        viewModel.loadCourses()
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testEmptyResponsePublishesEmptyState() async {
        let viewModel = CourseListViewModel(repository: StubRepository(result: CourseFetchResult(courses: [], isFromCache: false)))
        let expectation = expectation(description: "empty state")
        viewModel.onStateChange = { state in if case .empty = state { expectation.fulfill() } }
        viewModel.loadCourses()
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testRepositoryFailurePublishesFriendlyError() async {
        let viewModel = CourseListViewModel(repository: StubRepository(error: APIError.networkError))
        let expectation = expectation(description: "error state")
        viewModel.onStateChange = { state in
            if case .error(let message) = state { XCTAssertEqual(message, "Unable to load courses. Please try again."); expectation.fulfill() }
        }
        viewModel.loadCourses()
        await fulfillment(of: [expectation], timeout: 1)
    }
}

private struct StubRepository: CourseRepositoryProtocol {
    var result: CourseFetchResult?
    var error: Error?
    func fetchCourses() async throws -> CourseFetchResult {
        if let error { throw error }
        return result ?? CourseFetchResult(courses: [], isFromCache: false)
    }
    func updateCourse(_ course: Course) async throws {}
}
