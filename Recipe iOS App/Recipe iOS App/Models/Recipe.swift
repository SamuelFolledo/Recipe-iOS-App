//
//  Recipe.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

struct RecipeWrapper: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    var isValid: Bool {
        !name.isEmpty && !cuisine.isEmpty
    }

    init(id: String, name: String, cuisine: String, photoURLSmall: URL?, photoURLLarge: URL?, sourceURL: URL?, youtubeURL: URL?) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.photoURLSmall = photoURLSmall
        self.photoURLLarge = photoURLLarge
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }

    enum CodingKeys: String, CodingKey {
        case id = "uuid", name, cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }

    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
