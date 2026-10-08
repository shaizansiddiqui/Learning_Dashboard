import UIKit

final class CourseDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: CourseDetailsViewModel
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageLabel: UILabel!
    var onCourseUpdated: ((Course) -> Void)?

    init?(coder: NSCoder, viewModel: CourseDetailsViewModel) { self.viewModel = viewModel; super.init(coder: coder) }
    required init?(coder: NSCoder) { fatalError("Instantiate this screen with its injected view model.") }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 76
        viewModel.onStateChange = { [weak self] state in self?.render(state) }; render(.loaded(viewModel.course))
    }
    private func render(_ state: CourseDetailsViewModel.State) {
        switch state {
        case .loaded(let course):
            title = course.title; progressLabel.text = "\(course.instructor)  ·  \(course.progress)% complete"; progressView.progress = Float(course.progress) / 100; messageLabel.text = nil; tableView.reloadData()
            onCourseUpdated?(course)
        case .error(let message): messageLabel.text = message
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.course.lessons.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonCell.reuseIdentifier, for: indexPath) as? LessonCell else { return UITableViewCell() }
        cell.configure(with: viewModel.course.lessons[indexPath.row]); return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.completeLesson(at: indexPath.row); tableView.deselectRow(at: indexPath, animated: true)
    }
}
