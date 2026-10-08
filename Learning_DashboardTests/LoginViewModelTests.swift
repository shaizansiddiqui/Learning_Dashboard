import XCTest
@testable import Learning_Dashboard

@MainActor
final class LoginViewModelTests: XCTestCase {
    func testValidCredentialsAuthenticate() async {
        let viewModel = LoginViewModel(authenticationService: MockAuthenticationService(delayNanoseconds: 0))
        let expectation = expectation(description: "authenticated")
        viewModel.onStateChange = { state in if state == .authenticated { expectation.fulfill() } }
        viewModel.login(email: "test@example.com", password: "password123")
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testInvalidEmailFailsValidationWithoutCallingService() {
        let viewModel = LoginViewModel(authenticationService: MockAuthenticationService(delayNanoseconds: 0))
        viewModel.login(email: "invalid", password: "password123")
        XCTAssertEqual(viewModel.state, .error("Enter a valid email address."))
    }
}
