import XCTest
@testable import Postr

@MainActor
final class PostrTests: XCTestCase {

    func testParsing() async throws {

        let apiClient = ApiClient(getData: { _ in
            (#"""
            [
                {
                    "userId": 1,
                    "id": 0,
                    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
                }
            ]
            """#.data(using: .utf8)!, HTTPURLResponse(url: URL(filePath: "/"), statusCode: 200, httpVersion: nil, headerFields: nil)! as URLResponse)
        }, api: .production)

        let viewModel = ContentView.ViewModel(apiClient: apiClient, posts: [])
        try await viewModel.onAppear().value
        XCTAssertEqual(viewModel.posts.count, 1)
    }

    func testFiltersIdOver50() async throws {
        let apiClient = ApiClient(getData: { _ in
            (#"""
            [
                {
                    "userId": 1,
                    "id": 50,
                    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
                }
            ]
            """#.data(using: .utf8)!, HTTPURLResponse(url: URL(filePath: "/"), statusCode: 200, httpVersion: nil, headerFields: nil)! as URLResponse)
        }, api: .production)

        let viewModel = ContentView.ViewModel(apiClient: apiClient, posts: [])
        try await viewModel.onAppear().value
        XCTAssertEqual(viewModel.posts.count, 0)
    }

}
