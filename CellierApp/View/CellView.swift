//
//  CellView.swift
//  CellierApp
//
//  Created by Stagiaire on 18/04/2025.
//

import SwiftUI
 
struct CellView: View {
    
    var wine: Wine
    @ObservedObject var imageLoader = LoadImage()
    
    var body: some View {
//        NavigationLink(destination: DetailFilmView(film: film, imageLoader: imageLoader)) {
            HStack {
                // Image Section
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Film Info Section
                VStack(alignment: .trailing) {
                    Text(wine.wine)
                        .font(.title2)
                        .foregroundColor(.brown)
                    Text("Vignoble : \(wine.winery)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .italic()
                }
            }
            .padding()
            .onAppear {
                imageLoader.load(wine.image)
            }
        }
    }
//}
 
//#Preview {
//    let film: Film = Film(id: "1", title: "Mononoké", image: "https://fr.web.img2.acsta.net/pictures/21/02/09/12/46/1884055.jpg", description: "ceci est un test", director: "Joe Pesci", producer: "Elon Musk", release_date: "2025")
//    
//    return CellView(film: film)
//}
