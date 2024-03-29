

import SwiftUI

final class DetailViewModel: ObservableObject {
    @Published private(set) var movie: Movie?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    @MainActor
    func fetchDetails(for id: Int) async {
        viewState = .loading
        defer { viewState = .finished }
        do {
            self.movie = try await NetworkingManager.shared.request(.detail(id: id), type: nil)
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}

extension DetailViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
