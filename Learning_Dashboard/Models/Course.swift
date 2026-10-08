import Foundation

struct Course: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let instructor: String
    var lessons: [Lesson]

    var progress: Int {
        ProgressCalculator.calculateProgress(completedLessons: lessons.filter(\.isCompleted).count, totalLessons: lessons.count)
    }
}

struct Lesson: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    var isCompleted: Bool
}
