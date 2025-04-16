//
//  CacheManager.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import UIKit

protocol CacheManagerProtocol {
    func cacheRecipes(_ recipes: [Recipe], to endpoint: Endpoint) async
    func loadCachedRecipes(from endpoint: Endpoint) async -> [Recipe]

    func cacheImage(_ image: UIImage, forKey key: String) async
    func cachedImage(forKey key: String) async -> UIImage?
    func clearImageCache(forKey key: String) async
}

final class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    private init() {}

    private let recipeCache = DataCache<[Recipe]>(directoryName: "Recipes")
    private let imageCache = DataCache<Data>(directoryName: "Images")
    private let memoryCache = NSCache<NSString, UIImage>()
}

// MARK: - Recipe Caching Methods
extension CacheManager {
    func cacheRecipes(_ recipes: [Recipe], to endpoint: Endpoint) async {
        await recipeCache.save(recipes, forKey: endpoint.cacheKey)
    }

    func loadCachedRecipes(from endpoint: Endpoint) async -> [Recipe] {
        await recipeCache.load(forKey: endpoint.cacheKey) ?? []
    }
}

//MARK: - Image Caching Methods
extension CacheManager {
    func cacheImage(_ image: UIImage, forKey key: String) async {
        memoryCache.setObject(image, forKey: key as NSString)
        if let data = image.pngData() {
            await imageCache.save(data, forKey: key)
        }
    }

    func cachedImage(forKey key: String) async -> UIImage? {
        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            return memoryImage
        }
        if let data = await imageCache.load(forKey: key),
           let diskImage = UIImage(data: data) {
            memoryCache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        return nil
    }

    func clearImageCache(forKey key: String) async {
        memoryCache.removeObject(forKey: key as NSString)
        await imageCache.clear(forKey: key)
    }
}
