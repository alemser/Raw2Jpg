import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var sourceFolder: String = ""
    @Published var destinationFolder: String = ""
    @Published var imageList: [String] = []

    var cancellables: Set<AnyCancellable> = []

    init() {
        // Subscribe to the objectWillChange publisher to manually trigger updates
        $sourceFolder
            .merge(with: $destinationFolder)
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
