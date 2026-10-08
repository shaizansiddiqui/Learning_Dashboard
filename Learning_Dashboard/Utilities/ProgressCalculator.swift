import Foundation

enum ProgressCalculator {
    static func calculateProgress(completedLessons: Int, totalLessons: Int) -> Int {
        guard totalLessons > 0 else { return 0 }
        let completed = min(max(completedLessons, 0), totalLessons)
        return Int((Double(completed) / Double(totalLessons) * 100).rounded())
    }
}
