
import Foundation

final class TVViewModel: ObservableObject {
    @Published private(set) var popular: [Tv] = []
    @Published private(set) var airingToday: [Tv] = []
    @Published private(set) var tvTopRated: [Tv] = []
    @Published private(set) var onTheAir: [Tv] = []
    
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    @Published var hasAppeared = false
    
    @Published var page = 1
    private var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    @MainActor
    func fetchTV(from endpoint: Endpoint) async {
        viewState = .loading
        defer { viewState = .finished }
        do {
            let response = try await NetworkingManager.shared.request(endpoint, type: TVResponse.self)
            switch endpoint {
            case .tvPopular(page: page):
                self.popular = response.results
            case .airingToday(page: page):
                self.airingToday = response.results
            case .tvTopRated(page: page):
                self.tvTopRated = response.results
            case .onTheAir(page: page):
                self.onTheAir = response.results
            default:
                break
            }
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func populateTV() async {
        await fetchTV(from: .tvPopular(page: page))
        await fetchTV(from: .airingToday(page: page))
        await fetchTV(from: .tvTopRated(page: page))
        await fetchTV(from: .onTheAir(page: page))
    }
}

extension TVViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
