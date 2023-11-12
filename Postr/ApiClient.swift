
import Foundation

struct Api {
    let baseURL: URL

    static let production = Api(baseURL: URL(string: "https://jsonplaceholder.typicode.com/")!)
    static let development: Self = { fatalError("Not implemented") }()
}

struct ApiClient {
    let getData: (URL) async throws -> (Data, URLResponse)
    let api: Api

    func getPosts() async throws -> [Post] {
        try await get(url: api.baseURL.appending(component: "posts"))
    }
}

private extension ApiClient {
    enum URLError: Error {
        case notHTTP
        case statusCodeError(statusCode: Int)
    }

    func get<T: Decodable>(url: URL, type: T.Type = T.self) async throws -> T {
        let (data, response) = try await getData(url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError.notHTTP
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError.statusCodeError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
