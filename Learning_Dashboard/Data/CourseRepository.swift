import Foundation

struct CourseRepository: CourseRepositoryProtocol {
    let api: CourseAPIProtocol
    let cache: CourseCacheProtocol

    func fetchCourses() async throws -> CourseFetchResult {
        do {
            let courses = try await api.fetchCourses()
            try cache.save(courses)
            return CourseFetchResult(courses: courses, isFromCache: false)
        } catch {
            if let cached = try? cache.load() {
                return CourseFetchResult(courses: cached, isFromCache: true)
            }
            throw error
        }
    }

    func updateCourse(_ course: Course) async throws {
        guard var courses = try cache.load() else { throw APIError.unknown }
        guard let index = courses.firstIndex(where: { $0.id == course.id }) else { throw APIError.unknown }
        courses[index] = course
        try cache.save(courses)
    }
}
