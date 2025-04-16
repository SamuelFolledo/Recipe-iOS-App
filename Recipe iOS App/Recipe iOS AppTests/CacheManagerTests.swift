//
//  CacheManagerTests.swift
//  Recipe iOS AppTests
//
//  Created by Samuel Folledo on 4/16/25.
//

import Testing
import UIKit
@testable import Recipe_iOS_App

struct CacheManagerTests {
    let cacheManager = CacheManager.shared

    @Test func testCacheAndLoadRecipes() async {
        let recipes = [fakeRecipe]
        await cacheManager.cacheRecipes(recipes, to: .allRecipes)
        let loaded = await cacheManager.loadCachedRecipes(from: .allRecipes)
        #expect(loaded.count == 1)
        #expect(loaded.first?.id == fakeRecipe.id)
    }

    @Test func testCacheAndRetrieveImage() async {
        let image = UIImage(systemName: "star")!
        await cacheManager.cacheImage(image, forKey: "testKey")
        let cachedImage = await cacheManager.cachedImage(forKey: "testKey")
        #expect(cachedImage != nil)
        #expect(cachedImage?.pngData() == image.pngData())

        await cacheManager.clearImageCache(forKey: "testKey")
        let clearedImage = await cacheManager.cachedImage(forKey: "testKey")
        #expect(clearedImage == nil)
    }
}
