import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    var onLoginSuccess: (() -> Void)?
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!

    init?(coder: NSCoder, viewModel: LoginViewModel) { self.viewModel = viewModel; super.init(coder: coder) }
    required init?(coder: NSCoder) { fatalError("Instantiate this screen with its injected view model.") }

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        spinner.isHidden = true
        viewModel.onStateChange = { [weak self] state in self?.render(state) }
    }

    @IBAction private func loginTapped(_ sender: UIButton) { viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "") }
    private func render(_ state: LoginViewModel.State) {
        switch state {
        case .idle: errorLabel.text = nil; spinner.stopAnimating(); spinner.isHidden = true; loginButton.isEnabled = true
        case .loading: errorLabel.text = nil; spinner.isHidden = false; spinner.startAnimating(); loginButton.isEnabled = false
        case .error(let message): errorLabel.text = message; spinner.stopAnimating(); spinner.isHidden = true; loginButton.isEnabled = true
        case .authenticated: spinner.stopAnimating(); spinner.isHidden = true; onLoginSuccess?()
        }
    }
}
