import SwiftUI

struct ContentView: View {
    @Observable @MainActor
    class ViewModel {
        @ObservationIgnored
        let apiClient: ApiClient
        var posts: [Post] = []

        init(apiClient: ApiClient, posts: [Post] = []) {
            self.apiClient = apiClient
            self.posts = posts
        }

        @discardableResult
        func onAppear() -> Task<Void, Error> {
            Task {
                do {
                    self.posts = try await self.apiClient.getPosts().filter { post in
                        post.id.rawValue < 50
                    }
                } catch {
                    print("error: \(error)")
                    self.posts = []
                }
            }
        }

        func onRefresh() {
            onAppear()
        }

    }
    var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                }
            }.refreshable {
                viewModel.onRefresh()
            }
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView(
        viewModel: ContentView.ViewModel(
            apiClient: ApiClient(getData: { _ in try await Task<(Data, URLResponse), Error>.never() }, api: .production),
            posts: [Post(userId: Identifier(rawValue: 5), id: Identifier(rawValue: 4), title: "this is a title", body: "this is a body....")]
        )
    )
}

extension Task {
    static func never() async throws -> Success {
        for try await _ in (AsyncThrowingStream<Success, Error> { _ in }) { }
        fatalError("Should never happen")
    }
}

