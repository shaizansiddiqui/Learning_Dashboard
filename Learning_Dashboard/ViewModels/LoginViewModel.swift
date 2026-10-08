import Foundation

@MainActor
final class LoginViewModel {
    enum State: Equatable
    {
        case idle, loading, error(String), authenticated
    }
    private let authenticationService: AuthenticationServiceProtocol
    private(set) var state: State = .idle { didSet { onStateChange?(state) } }
    var onStateChange: ((State) -> Void)?

    init(authenticationService: AuthenticationServiceProtocol) { self.authenticationService = authenticationService }

    func login(email: String, password: String) {
        guard state != .loading else { return }
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidEmail(trimmedEmail) else { state = .error("Enter a valid email address."); return }
        guard password.count >= 6 else { state = .error("Password must be at least 6 characters."); return }
        state = .loading
        Task {
            do {
                try await authenticationService.login(email: trimmedEmail, password: password)
                state = .authenticated
            } catch {
                state = .error("Those credentials didn’t work. Try test@example.com and password123.")
            }
        }
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        return parts.count == 2 && parts[0].count > 0 && parts[1].contains(".") && !parts[1].hasPrefix(".") && !parts[1].hasSuffix(".")
    }
}
