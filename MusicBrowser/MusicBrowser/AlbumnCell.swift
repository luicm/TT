//
//  AlbumnCell.swift
//  MusicBrowser
//
//  Created by Luisa Cruz Molina on 02.03.21.
//

import SwiftUI
import Kingfisher

struct AlbumnCell: View {
    var albumn: Albumn
    
    var body: some View {
        
        HStack {
            KFImage.url(albumn.cover)
                .placeholder {
                        // Placeholder while downloading.
                        Image(systemName: "music.mic")
                            .font(.largeTitle)
                            .opacity(0.3)
                    }
                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipped()
            
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
