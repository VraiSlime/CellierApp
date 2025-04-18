//
//  ImageLoader.swift
//  Ghibli
//
//  Created by Stagiaire on 17/04/2025.
//
 
import SwiftUI
import Combine
 
class LoadImage: ObservableObject {
    @Published var image: UIImage?

    func load(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }
        .resume()
    }
}
