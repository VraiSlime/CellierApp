//  JsonResponse.swift
//  WinesAPI
//
//  Created by Stagiaire on 18/04/2025.
//

import Foundation

struct Wine: Identifiable, Decodable {
    let id: Int
    let winery: String
    let wine: String
    let rating: Rating
    var location: String
    var image: String

    // Champs supplémentaires pour le formulaire
    var type: String?
    var year: Int?
    var quantity: Int?
    var purchaseLocation: String?
}

struct Rating: Decodable {
    let average: String
    let reviews: String
}


