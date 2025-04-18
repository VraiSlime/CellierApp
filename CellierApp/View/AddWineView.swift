import SwiftUI

// MARK: – Formulaire d’ajout de vin avec URL d’image distante
struct AddWineView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var wineGetter: WineGetter

    // Loader pour afficher l’aperçu de l’image
    @StateObject private var imageLoader = LoadImage()

    // Types de vin autorisés (endpoint API)
    private static let wineTypes = ["reds", "whites", "rose", "sparkling"]

    // Champs du formulaire
    @State private var winery           = ""
    @State private var name             = ""
    @State private var type             = wineTypes.first!
    @State private var year             = ""
    @State private var quantity         = ""
    @State private var purchaseLocation = ""
    @State private var imageURL         = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Identité")) {
                    TextField("Nom du vin", text: $name)
                    TextField("Domaine",     text: $winery)
                    Picker("Type", selection: $type) {
                        ForEach(Self.wineTypes, id: \.self) { t in
                            Text(t.capitalized).tag(t)
                        }
                    }
                }

                Section(header: Text("Détails")) {
                    TextField("Année", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Quantité", text: $quantity)
                        .keyboardType(.numberPad)
                    TextField("Lieu d’achat", text: $purchaseLocation)
                }

                Section(header: Text("Image (URL distante)")) {
                    TextField("URL de l’image", text: $imageURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                        .onChange(of: imageURL) {
                            imageLoader.load(imageURL)
                        }

                    if let uiImage = imageLoader.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                    } else if !imageURL.isEmpty {
                        ProgressView().frame(height: 150)
                    }
                }
            }
            .navigationTitle("Ajouter un vin")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: saveWine) {
                        Text("Enregistrer")
                    }
                    .disabled(!isFormValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    // MARK: – Validation
    private var isFormValid: Bool {
        !name.isEmpty
        && !winery.isEmpty
        && !type.isEmpty
        && Int(year) != nil
        && Int(quantity) != nil
        && URL(string: imageURL) != nil
    }

    // MARK: – Sauvegarde
    private func saveWine() {
        guard
            let yr  = Int(year),
            let qty = Int(quantity)
        else { return }

        // 1️⃣ Génère un nouvel ID
        let newId = (wineGetter.wines.map(\.id).max() ?? 0) + 1

        // 2️⃣ Crée une note par défaut puisque Rating est requis
        let defaultRating = Rating(average: "0.0", reviews: "0")

        // 3️⃣ Construit le modèle Wine en passant :
        //    - rating : defaultRating
        //    - location : purchaseLocation (le lieu d’achat)
        let newWine = Wine(
            id:               newId,
            winery:           winery,
            wine:             name,
            rating:           defaultRating,
            location:         purchaseLocation,
            image:            imageURL,
            type:             type,
            year:             yr,
            quantity:         qty,
            purchaseLocation: purchaseLocation
        )

        // 4️⃣ Ajoute-le à votre getter et ferme la vue
        wineGetter.add(wine: newWine)
        presentationMode.wrappedValue.dismiss()
    }

struct AddWineView_Previews: PreviewProvider {
    static var previews: some View {
        AddWineView(wineGetter: WineGetter())
    }}
}
