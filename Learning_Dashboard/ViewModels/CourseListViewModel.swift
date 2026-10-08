import Foundation

@MainActor
final class CourseListViewModel {
    enum State: Equatable { case idle, loading, loaded([Course], message: String?), empty, error(String) }
    private let repository: CourseRepositoryProtocol
    private(set) var state: State = .idle { didSet { onStateChange?(state) } }
    var onStateChange: ((State) -> Void)?

    init(repository: CourseRepositoryProtocol) { self.repository = repository }
    func loadCourses() {
        guard state != .loading else { return }
        state = .loading
        Task {
            do {
                let result = try await repository.fetchCourses()
                if result.courses.isEmpty { state = .empty }
                else { state = .loaded(result.courses, message: result.isFromCache ? "You’re viewing your saved courses." : nil) }
            } catch { state = .error("Unable to load courses. Please try again.") }
        }
    }
}
