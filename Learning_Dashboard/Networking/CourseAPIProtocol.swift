import Foundation

protocol CourseAPIProtocol {
    func fetchCourses() async throws -> [Course]
}

protocol APIClientProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

struct URLSessionAPIClient: APIClientProtocol {
    let session: URLSession
    init(session: URLSession = .shared) { self.session = session }
    func data(for request: URLRequest) async throws -> (Data, URLResponse) { try await session.data(for: request) }
}

struct URLSessionCourseAPI: CourseAPIProtocol {
    let client: APIClientProtocol
    let endpoint: URL

    func fetchCourses() async throws -> [Course] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await client.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }
            guard (200..<300).contains(response.statusCode) else { throw APIError.serverError }
            do { return try JSONDecoder().decode([Course].self, from: data) }
            catch { throw APIError.decodingError }
        } catch let error as APIError { throw error }
        catch { throw APIError.networkError }
    }
}
