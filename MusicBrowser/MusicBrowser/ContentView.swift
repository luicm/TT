
import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: StoreOf<MusicBrowser>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List(viewStore.orderedAlbumns) {
                        AlbumnCell(albumn: $0)
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(
                text: viewStore.binding(
                get: { $0.searchQuery },
                send: MusicBrowser.Action.searchQueryChanged
            ),
                prompt: Text("Looking for ...")
            )
            .task { viewStore.send(.loadAlbums) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: .init(
                initialState: MusicBrowser.State(),
                reducer: MusicBrowser()
            )
        )
    }
}
