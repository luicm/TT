//
//  MusicBrowserApp.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 27.02.21.
//

import SwiftUI
import ComposableArchitecture

@main
struct MusicBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        client: .live,
                        mainQueue:  DispatchQueue.main.eraseToAnyScheduler()
                    )
                )
            )
        }
    }
}
