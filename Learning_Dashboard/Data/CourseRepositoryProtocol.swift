import Foundation

protocol CourseRepositoryProtocol {
    func fetchCourses() async throws -> CourseFetchResult
    func updateCourse(_ course: Course) async throws
}

struct CourseFetchResult {
    let courses: [Course]
    let isFromCache: Bool
}
