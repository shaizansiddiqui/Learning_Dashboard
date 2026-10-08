import Foundation

struct MockAuthenticationService: AuthenticationServiceProtocol {
    var delayNanoseconds: UInt64 = 500_000_000
    func login(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        guard email.lowercased() == "test@example.com", password == "password123" else { throw LoginError.invalidCredentials }
    }
}

enum LoginError: Error { case invalidCredentials }
