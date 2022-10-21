import ComposableArchitecture
import Foundation

enum MusicClientKey: DependencyKey {
    static var liveValue: MusicClient = .live
    //TODO: mock preview results
//    static var previewValue: MusicClient = .preview
}

extension DependencyValues {
    var musicClient: MusicClient {
        get { self[MusicClientKey.self] }
        set { self[MusicClientKey.self] = newValue}
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
                    guard let response = output.response as? HTTPURLResponse else {
                        fatalError()
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

extension MusicClient {
    
    static let preview = MusicClient(
        requestAlbums: {
            //TODO: mock preview results
            .init(value: [])
        }
    )
}
