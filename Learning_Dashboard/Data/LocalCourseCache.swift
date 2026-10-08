import Foundation

protocol CourseCacheProtocol {
    func save(_ courses: [Course]) throws
    func load() throws -> [Course]?
}

struct LocalCourseCache: CourseCacheProtocol {
    private let fileManager: FileManager
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        self.fileURL = directory.appendingPathComponent("LearningDashboard", isDirectory: true).appendingPathComponent("courses.json")
    }

    func save(_ courses: [Course]) throws {
        let directory = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(courses)
        try data.write(to: fileURL, options: .atomic)
    }

    func load() throws -> [Course]? {
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        do { return try JSONDecoder().decode([Course].self, from: Data(contentsOf: fileURL)) }
        catch {
            try? fileManager.removeItem(at: fileURL)
            return nil
        }
    }
}
