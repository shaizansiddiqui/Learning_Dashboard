import UIKit

final class CourseCell: UITableViewCell {
    static let reuseIdentifier = "CourseCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var instructorLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var lessonCountLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    var onContinue: (() -> Void)?

    func configure(with course: Course) {
        titleLabel.text = course.title
        instructorLabel.text = course.instructor
        progressLabel.text = "Progress \(course.progress)%"
        progressView.progress = Float(course.progress) / 100
        lessonCountLabel.text = "\(course.lessons.count) lessons"
        accessibilityIdentifier = "course-cell-\(course.id)"
    }

    @IBAction private func continueTapped(_ sender: UIButton) { onContinue?() }
}
