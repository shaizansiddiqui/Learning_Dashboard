import Foundation

protocol AuthenticationServiceProtocol {
    func login(email: String, password: String) async throws
}
