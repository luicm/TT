//
//  AppState.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 27.02.21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct MusicBrowser: ReducerProtocol {
    /// Controls states and actions that concern logic or modification  of the app globally
    struct State: Equatable {
        var albumns: [Albumn] = []
        var orderedAlbumns: [Albumn] = []
        var searchQuery = ""
    }
    
    enum Action: Equatable {
        case loadAlbums
        case loadAlbumsResponse(Result<[Albumn], MusicClient.Failure>)
        case orderAlbumnsAlphabeticaly([Albumn])
        case searchQueryChanged(String)
        case filter(String)
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.musicClient) var musicClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadAlbums:
                return musicClient.requestAlbums()
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.loadAlbumsResponse)
                
            case let .loadAlbumsResponse(.success(albumns)):
                state.albumns = albumns
                return Effect(value: .orderAlbumnsAlphabeticaly(albumns))
                
            case .loadAlbumsResponse(.failure):
                return .none
                
            case .orderAlbumnsAlphabeticaly(let albumns):
                state.orderedAlbumns = albumns.sorted { $0.album < $1.album }
                return .none
                
            case let .searchQueryChanged(query):
                struct SearchAlbumnId: Hashable {}
                
                state.searchQuery = query
                
                guard !query.isEmpty else {
                    return Effect(value: .orderAlbumnsAlphabeticaly(state.albumns))
                }
                
                return Effect(value: .filter(query))
                    .debounce(id: SearchAlbumnId(), for: 0.3, scheduler: mainQueue)
                
            case .filter(let query):
                let filteredAlbumns = state.albumns.filter { albumn -> Bool in
                    return albumn.album.localizedStandardContains(query)
                }
                
                return Effect(value: .orderAlbumnsAlphabeticaly(filteredAlbumns))
            }
        }
    }
}
