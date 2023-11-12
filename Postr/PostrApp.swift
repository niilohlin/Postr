import SwiftUI

@main
struct PostrApp: App {
    var body: some Scene {
        let apiClient = ApiClient(getData: URLSession.shared.data(from:), api: .production)
        let viewModel = ContentView.ViewModel(apiClient: apiClient)
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
