//
//  ContentView.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 27.02.21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                  Image(systemName: "magnifyingglass")
                  TextField(
                    "Looking for ..."
                    ,
                    text: viewStore.binding(
                        get: { $0.searchQuery }, send: AppAction.searchQueryChanged)
                  )
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .autocapitalization(.none)
                  .disableAutocorrection(true)
                }
                .padding([.leading, .trailing], 16)
                
                List(viewStore.orderedAlbumns) {
                    AlbumnCell(albumn: $0)
                    }
                    .padding()
            }.onAppear { viewStore.send(.loadAlbums) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    client: .live,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
