
import SwiftUI
import ComposableArchitecture

@main
struct MusicBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: MusicBrowser.State(),
                    reducer: MusicBrowser()
                )
            )
        }
    }
}
