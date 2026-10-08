import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let mockAPI = MockCourseAPI()
        // Set to true to demo the repository's cached-data fallback after a successful load.
         mockAPI.shouldFail = true
        let repository = CourseRepository(api: mockAPI, cache: LocalCourseCache())
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let login = storyboard.instantiateViewController(identifier: "LoginViewController") { coder in
            LoginViewController(coder: coder, viewModel: LoginViewModel(authenticationService: MockAuthenticationService()))
        }
        let navigationController = UINavigationController(rootViewController: login)
        login.onLoginSuccess = { [weak navigationController] in
            let dashboard = storyboard.instantiateViewController(identifier: "CourseDashboardViewController") { coder in
                CourseDashboardViewController(coder: coder, repository: repository)
            }
            navigationController?.setViewControllers([dashboard], animated: true)
        }
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
