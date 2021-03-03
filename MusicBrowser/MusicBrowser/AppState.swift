//
//  AppState.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 27.02.21.
//

import Foundation
import ComposableArchitecture
import SwiftUI


/// Controls states and actions that concern logic or modification  of the app globally
struct AppState: Equatable {
    var albumns: [Albumn] = []
    var orderedAlbumns: [Albumn] = []
    var searchQuery = ""
}


enum AppAction: Equatable {
    case loadAlbums
    case loadAlbumsResponse(Result<[Albumn], MusicClient.Failure>)
    case orderAlbumnsAlphabeticaly([Albumn])
    case searchQueryChanged(String)
    case filter(String)
}

struct AppEnvironment {
    var client: MusicClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}


let appReducer = Reducer<AppState, AppAction, AppEnvironment>.init { (state, action, environment) -> Effect<AppAction, Never> in
    switch action {
    
    case .loadAlbums:
        return environment.client.requestAlbums()
            .catchToEffect()
            .map(AppAction.loadAlbumsResponse)
        
    case let .loadAlbumsResponse(.success(albumns)):
        state.albumns = albumns
        return Effect(value: .orderAlbumnsAlphabeticaly(albumns))
        
    case .orderAlbumnsAlphabeticaly(let albumns):
        state.orderedAlbumns = albumns.sorted { $0.album < $1.album }
        return .none
        
    case .loadAlbumsResponse(.failure):
        return .none
        
    case let .searchQueryChanged(query):
        struct SearchAlbumnId: Hashable {}
        
        state.searchQuery = query
        
        guard !query.isEmpty else {
            return Effect(value: .orderAlbumnsAlphabeticaly(state.albumns))
        }
        
        return Effect(value: .filter(query))
            .debounce(id: SearchAlbumnId(), for: 0.3, scheduler: environment.mainQueue)
        
    case .filter(let query):
        let filteredAlbumns = state.albumns.filter { albumn -> Bool in
           return albumn.album.localizedStandardContains(query)
        }

        return Effect(value: .orderAlbumnsAlphabeticaly(filteredAlbumns))
    }
}

struct MusicClient {
    var requestAlbums: () -> Effect<[Albumn], Failure>
    
    enum Failure: Error, Equatable {
        case HTTPError
    }
}


extension MusicClient {
    
    static let live = MusicClient(
        requestAlbums: {
            let url = URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json")
            let request = URLRequest(url: url!)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse else { fatalError()
                    }
                    guard response.statusCode == 200 else {
                        throw MusicClient.Failure.HTTPError
                    }
                    
                    return output.data
                }
                .decode(type: [Albumn].self, decoder: decoder)
                .mapError { $0 as! MusicClient.Failure }
                .eraseToEffect()
            
        }
    )
}
