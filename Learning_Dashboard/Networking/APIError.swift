import Foundation

enum APIError: Error {
    case invalidResponse
    case networkError
    case decodingError
    case serverError
    case unknown
}
