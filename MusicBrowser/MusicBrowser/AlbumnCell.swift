
import SwiftUI

struct AlbumnCell: View {
    var albumn: Albumn
    
    var body: some View {
        
        HStack {
            AsyncImage(url: albumn.cover) { image in
                image
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                // Placeholder while downloading.
                Image(systemName: "music.mic")
                    .font(.largeTitle)
                    .frame(width: 100, height: 100, alignment: .center)
                    .opacity(0.3)
            }

            VStack(alignment: .leading) {
                Text(albumn.album).bold()
                    .padding(.bottom, 3)
                
                HStack(alignment: .bottom) {
                    Text(albumn.artist)
                    Spacer()
                    Text(albumn.year).font(.caption)
                }
                Spacer()
            }.padding([.top, .trailing], 8)
        }
    }
}

struct AlbumnCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumnCell(albumn: Albumn.showPlaceholder())
                .previewLayout(.fixed(width: 375, height: 100))
        }
    }
}
