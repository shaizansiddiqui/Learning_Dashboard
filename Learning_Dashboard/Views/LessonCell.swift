import UIKit

final class LessonCell: UITableViewCell {
    static let reuseIdentifier = "LessonCell"

    func configure(with lesson: Lesson) {
        var content = defaultContentConfiguration()
        content.text = lesson.title
        content.secondaryText = lesson.isCompleted ? "Completed" : "Tap to mark complete"
        content.image = UIImage(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
        content.imageProperties.tintColor = lesson.isCompleted ? .systemGreen : .tertiaryLabel
        contentConfiguration = content
        accessibilityIdentifier = "lesson-cell-\(lesson.id)"
        accessoryType = lesson.isCompleted ? .checkmark : .none
    }
}
