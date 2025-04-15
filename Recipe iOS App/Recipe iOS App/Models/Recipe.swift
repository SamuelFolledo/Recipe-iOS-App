//
//  Recipe.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

// Recipe Model
struct RecipeWrapper: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    var isValid: Bool {
        !name.isEmpty && !cuisine.isEmpty
    }

    enum CodingKeys: String, CodingKey {
        case id = "uuid", name, cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
