//  ContentView.swift
//  CellierApp
//
//  Created by Stagiaire on 18/04/2025.
//

import SwiftUI

struct ContentView: View {
    // Keep one WineGetter alive for this view
    @StateObject private var wineGetter = WineGetter()
    @State private var showingAddForm = false

    var body: some View {
        NavigationView {
            List(wineGetter.wines) { wine in
                CellView(wine: wine)
            }
            .navigationTitle("Ma Cave 🍷")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                wineGetter.getAll()
            }
            // Note the $ on showingAddForm to get a Binding<Bool>
            .sheet(isPresented: $showingAddForm) {
                AddWineView(wineGetter: wineGetter)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
