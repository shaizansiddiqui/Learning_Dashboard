# Learning Dashboard

UIKit learning app for iOS 17+. Demo login: `test@example.com` / `password123`.

## 1. Architecture

The app uses MVVM and a repository because they keep UIKit rendering, screen behavior, and data access separate while remaining small enough to explain. `Main.storyboard` defines login, dashboard, details, and table cell layouts; `LaunchScreen.storyboard` defines the launch screen. View models publish states through closures, and initializer injection makes services replaceable in tests. `CourseRepository` coordinates `CourseAPIProtocol` and `CourseCacheProtocol`; `URLSessionCourseAPI` can replace the mock without changing the screens.

## 2. Offline support

Successful responses are encoded with Codable and saved as `courses.json` in Application Support using FileManager. The repository tries the API first and returns cached courses on failure. Corrupt cache files are discarded; with no cache, the dashboard shows a retry state. Lesson updates are saved through the repository. To demo fallback, load courses once, uncomment `mockAPI.shouldFail = true` in `SceneDelegate.swift`, and relaunch.

## 3. Security

The mock login stores no credentials. A production app should use HTTPS and store authentication tokens in Keychain, with token expiration and refresh handling. Never log passwords or tokens.

## 4. Scale

- Add pagination and server-side search/filtering.
- Cache responses at the API/CDN layer and define cache invalidation.
- Index backend queries and optimize database access.
- Add monitoring, crash reporting, and request tracing.
- Consider background refresh and incremental sync.

## 5. Android implementation

Use Kotlin with a ViewModel and Repository, Retrofit/OkHttp for HTTP, Room for offline storage, and Coroutines/Flow for asynchronous state. The presentation can use Jetpack Compose or XML; the data and state boundaries stay the same.

Progress is derived from completed lessons. The mock course lesson counts match the assignment. With 16 equally weighted lessons, 6 completed lessons produce 38%; the example 40% cannot be represented exactly as a whole number of completed lessons.

## Run and test

Open `Learning_Dashboard.xcodeproj`, select the `Learning_Dashboard` scheme, and run on an iOS 17+ simulator or device. Run XCTest with Product → Test in Xcode. No third-party packages are required.
