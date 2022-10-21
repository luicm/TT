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
                send: AppAction.searchQueryChanged
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


//struct SearchWithList: View {
//    @State private var searchString = ""
//    @State private var courses = DTCourse.sample
//    var body: some View {
//        NavigationView {
//            List(courses) { course in
//                Text(course.title) .font(.title)
//            }
//            .searchable(text: $searchString)
//            .onChange(of: searchString, perform: { newValue in if newValue.isEmpty { courses = DTCourse.sample } else { courses = DTCourse.sample.filter { $0.title.lowercased().hasPrefix(searchString.lowercased())} } }) .navigationTitle("DevTechie.com") } } }
