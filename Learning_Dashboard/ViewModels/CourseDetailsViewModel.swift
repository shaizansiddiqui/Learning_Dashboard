import Foundation

@MainActor
final class CourseDetailsViewModel {
    enum State: Equatable { case loaded(Course), error(String) }
    private(set) var course: Course
    private let repository: CourseRepositoryProtocol
    private(set) var state: State { didSet { onStateChange?(state) } }
    var onStateChange: ((State) -> Void)?

    init(course: Course, repository: CourseRepositoryProtocol) {
        self.course = course
        self.repository = repository
        self.state = .loaded(course)
    }

    func completeLesson(at index: Int) {
        guard course.lessons.indices.contains(index), !course.lessons[index].isCompleted else { return }
        course.lessons[index].isCompleted = true
        state = .loaded(course)
        Task {
            do { try await repository.updateCourse(course) }
            catch { state = .error("Progress changed, but couldn’t be saved on this device.") }
        }
    }
}
