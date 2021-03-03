import UIKit

var json = """
[
{
    "album" : "We Are Not Your Kind",
    "artist" : "Slipknot",
    "id" : "1463706038",
    "label" : "Roadrunner Records",
"cover" : "https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/2b/4d/97/2b4d97a1-d445-c0f9-6f95-f602392ec362/016861741006.jpg/128x128bb.jpeg",
    "tracks" : [
      "Insert Coin",
      "Unsainted",
      "Birth of the Cruel",
      "Death Because of Death",
      "Nero Forte",
      "Critical Darling",
      "A Liar's Funeral",
      "Red Flag",
      "What's Next",
      "Spiders",
      "Orphan",
      "My Pain",
      "Not Long for This World",
      "Solway Firth"
    ],
    "year" : "2019"
  }
]

""".data(using: .utf8)


struct Album: Codable {
    let album: String
    let artist: String
    let cover: URL
    let id: String
    let label: String
    let tracks: [String]
    let year: String
}


let decoder = JSONDecoder()
let albumns = try! decoder.decode([Album].self, from: json!)
print(albumns)
