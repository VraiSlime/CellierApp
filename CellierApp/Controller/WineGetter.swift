import Foundation
import Combine

class WineGetter: ObservableObject {
    @Published var wines: [Wine] = []
    @Published var errorMessage: String?

    //
    private func getFromAPI(endpoint: String,  append: Bool = false) {
        let urlString = "https://api.sampleapis.com/wines/\(endpoint)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { self.errorMessage = "URL invalide" }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Pas de données reçues"
                }
                return
            }
            do {
                let result = try JSONDecoder().decode([Wine].self, from: data)
                DispatchQueue.main.async {
                    self.wines = result
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Décodage échoué : \(error.localizedDescription)"
                }
            }
        }
        .resume()
    }

    // Récupère uniquement les vins rouges
    func getReds() {
        getFromAPI(endpoint: "reds")
    }

    // Récupère uniquement les vins blancs
    func getWhites() {
        getFromAPI(endpoint: "whites")
    }

    // Récupère uniquement les rosés
    func getRose() {
        getFromAPI(endpoint: "rose")
    }

    // Récupère uniquement les vins pétillants
    func getSparkling() {
        getFromAPI(endpoint: "sparkling")
    }
    
    // Récupère TOUS les vins (append chaque catégorie dans le même tableau)
        func getAll() {
            // On vide d’abord le tableau
            self.wines = []
            // On « append » chaque catégorie
            getFromAPI(endpoint: "reds", append: true)
            getFromAPI(endpoint: "whites", append: true)
            getFromAPI(endpoint: "rose", append: true)
            getFromAPI(endpoint: "sparkling", append: true)
        }
    
    func add(wine: Wine) {
            DispatchQueue.main.async {
                self.wines.append(wine)
            }
        }
}
