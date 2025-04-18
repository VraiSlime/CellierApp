import SwiftUI
import CoreData

struct ListBottleView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: WineBottle.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WineBottle.name, ascending: true)],
        animation: .default
    )
    private var bottles: FetchedResults<WineBottle>

    @State private var showingAddForm = false

    var body: some View {
        List {
            ForEach(bottles, id: \.self) { bottle in
                VStack(alignment: .leading) {
                    Text(bottle.name ?? "—").font(.headline)
                    Text(bottle.winery ?? "—").font(.subheadline)
                }
            }
            .onDelete(perform: deleteBottles)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Cellier")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAddForm = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddForm) {
            AddWineView(wineGetter: WineGetter())
        }
    }

    private func deleteBottles(at offsets: IndexSet) {
        offsets.map { bottles[$0] }.forEach(viewContext.delete)
        save()
    }

    private func save() {
        try? viewContext.save()
    }
}
