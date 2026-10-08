import Foundation

final class MockCourseAPI: CourseAPIProtocol {
    var shouldFail = false
    var courses: [Course] = MockCourseAPI.sampleCourses
    var delayNanoseconds: UInt64 = 350_000_000

    func fetchCourses() async throws -> [Course] {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        if shouldFail { throw APIError.networkError }
        return courses
    }

    static let sampleCourses: [Course] = [
        Course(id: 1, title: "Python Programming", instructor: "John Smith", lessons: makeLessons(
            ["Introduction", "Variables & Data Types", "Functions", "OOP", "Modules", "Error Handling"], totalCount: 20, completedCount: 13
        )),
        Course(id: 2, title: "Generative AI", instructor: "Sarah Williams", lessons: makeLessons(
            ["AI Foundations", "Prompt Engineering", "Working with Models", "Responsible AI", "Build an Assistant"], totalCount: 16, completedCount: 6
        )),
        Course(id: 3, title: "Full Stack Development", instructor: "David Brown", lessons: makeLessons(
            ["Web Fundamentals", "HTML & CSS", "JavaScript", "APIs", "Databases", "Deployment"], totalCount: 28, completedCount: 7
        ))
    ]

    private static func makeLessons(_ topics: [String], totalCount: Int, completedCount: Int) -> [Lesson] {
        (0..<totalCount).map { index in
            let title = index < topics.count ? topics[index] : "Lesson \(index + 1)"
            return Lesson(id: index + 1, title: title, isCompleted: index < completedCount)
        }
    }
}
