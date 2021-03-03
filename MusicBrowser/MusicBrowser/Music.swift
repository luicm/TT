//
//  Music.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 27.02.21.
//

import Foundation

struct Albumn: Codable, Equatable, Identifiable {
    let album: String
    let artist: String
    let cover: URL
    let id: String
    let label: String
    let tracks: [String]
    let year: String
}
