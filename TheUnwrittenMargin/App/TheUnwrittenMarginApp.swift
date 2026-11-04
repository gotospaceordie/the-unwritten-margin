import SwiftUI

@main
struct TheUnwrittenMarginApp: App {
    @State private var model: AppModel = {
        do {
            return try AppModel.sample()
        } catch {
            fatalError("Could not load sample content: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
        }
    }
}
