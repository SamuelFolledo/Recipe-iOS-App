//
//  Recipe.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import UIKit

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

extension Recipe {
    func loadImage(isLarge: Bool) async -> UIImage? {
        guard let url = isLarge ? photoURLLarge : photoURLSmall else {
            return nil
        }
        if let cached = await CacheManager.shared.cachedImage(forKey: id) {
            return cached
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            await CacheManager.shared.cacheImage(image, forKey: id)
            return image
        } catch {
            return nil
        }
    }
}
