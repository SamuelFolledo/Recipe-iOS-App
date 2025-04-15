//
//  CacheManager.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import UIKit

protocol CacheManagerProtocol {
    func cacheRecipes(_ recipes: [Recipe]) async
    func loadCachedRecipes() async -> [Recipe]
    func clearImageCache(for recipeID: UUID)
}

final class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    private init() {}

    private let recipeCache = DataCache<[Recipe]>(filename: "recipes_cache.json")
    private let imageCache = ImageCache.shared
}

// MARK: - Recipe Caching Methods
extension CacheManager {
    func cacheRecipes(_ recipes: [Recipe]) async {
        await recipeCache.save(recipes)
    }

    func loadCachedRecipes() async -> [Recipe] {
        await recipeCache.load() ?? []
    }
}

//MARK: - Image Caching Methods
extension CacheManager {
    func clearImageCache(for recipeID: UUID) {
        imageCache.clearCache(for: recipeID.uuidString)
    }

    func image(for recipe: Recipe, size: ImageSize) async -> UIImage? {
        guard let url = imageURL(for: recipe, size: size) else { return nil }
        return await imageCache.image(for: recipe.id.uuidString, remoteURL: url)
    }

    private func imageURL(for recipe: Recipe, size: ImageSize) -> URL? {
        switch size {
        case .small: return recipe.photoURLSmall
        case .large: return recipe.photoURLLarge
        }
    }
}
