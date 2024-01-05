
import SwiftUI

final class GridViewModel: ObservableObject {
    
    @Published var isListViewActive = false
    @Published private(set) var gridLayout = Array(repeating: GridItem(.flexible()), count: 3)
}
