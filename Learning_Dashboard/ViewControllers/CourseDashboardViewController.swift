import UIKit

final class CourseDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: CourseListViewModel
    private let repository: CourseRepositoryProtocol
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var stateContainer: UIView!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    private var courses: [Course] = []

    init?(coder: NSCoder, repository: CourseRepositoryProtocol) { self.repository = repository; self.viewModel = CourseListViewModel(repository: repository); super.init(coder: coder) }
    required init?(coder: NSCoder) { fatalError("Instantiate this screen with its injected repository.") }

    override func viewDidLoad() {
        super.viewDidLoad(); title = "My Courses"
        tableView.dataSource = self; tableView.delegate = self
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        spinner.isHidden = true
        viewModel.onStateChange = { [weak self] state in self?.render(state) }
        viewModel.loadCourses()
    }

    @IBAction private func reload() { viewModel.loadCourses() }
    @IBAction private func retry() { viewModel.loadCourses() }
    private func render(_ state: CourseListViewModel.State) {
        switch state {
        case .idle: spinner.stopAnimating(); spinner.isHidden = true
        case .loading: spinner.isHidden = false; spinner.startAnimating(); tableView.isHidden = true; stateContainer.isHidden = true
        case .loaded(let newCourses, let message):
            spinner.stopAnimating(); spinner.isHidden = true; stateContainer.isHidden = true; tableView.isHidden = false; courses = newCourses; tableView.reloadData()
            if let message { let banner = UILabel(); banner.text = message; banner.textColor = .secondaryLabel; banner.textAlignment = .center; banner.font = .preferredFont(forTextStyle: .footnote); banner.numberOfLines = 0; tableView.tableHeaderView = banner; banner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36) }
            else { tableView.tableHeaderView = nil }
        case .empty: spinner.stopAnimating(); spinner.isHidden = true; tableView.isHidden = true; stateContainer.isHidden = false; stateLabel.text = "No courses yet. Check back soon."; retryButton.isHidden = true
        case .error(let message): spinner.stopAnimating(); spinner.isHidden = true; tableView.isHidden = true; stateContainer.isHidden = false; stateLabel.text = message; retryButton.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { courses.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.reuseIdentifier, for: indexPath) as? CourseCell else { return UITableViewCell() }
        let course = courses[indexPath.row]; cell.configure(with: course)
        cell.onContinue = { [weak self] in self?.showDetails(for: course) }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { showDetails(for: courses[indexPath.row]) }
    private func showDetails(for course: Course) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let details = storyboard.instantiateViewController(identifier: "CourseDetailsViewController") { coder in
            CourseDetailsViewController(coder: coder, viewModel: CourseDetailsViewModel(course: course, repository: self.repository))
        }
        details.onCourseUpdated = { [weak self] updatedCourse in
            guard let self, let index = self.courses.firstIndex(where: { $0.id == updatedCourse.id }) else { return }
            self.courses[index] = updatedCourse
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        navigationController?.pushViewController(details, animated: true)
    }
}
