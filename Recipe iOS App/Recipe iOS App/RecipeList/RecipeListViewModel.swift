//
//  RecipeListViewModel.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: RecipeError?

    // MARK: - Dependencies
    private let service: RecipeServiceProtocol
    private let cacheManager: CacheManagerProtocol

    // MARK: - Initialization
    init(service: RecipeServiceProtocol = RecipeService(), cacheManager: CacheManagerProtocol = CacheManager.shared) {
        self.service = service
        self.cacheManager = cacheManager
    }

    // MARK: - Public Methods
    func loadRecipes() async {
        error = nil
        isLoading = true
        do {
            await loadCachedRecipes()
            let newRecipes = try await service.fetchRecipes()
            let mergedRecipes = await mergeRecipes(newRecipes)
            recipes = mergedRecipes
            await cacheManager.cacheRecipes(mergedRecipes)
        } catch let error as RecipeError {
            handleError(error)
        } catch {
            handleError(.unknown(error))
        }
        isLoading = false
    }

    // MARK: - Cache Management
    private func loadCachedRecipes() async {
        let cachedRecipes = await cacheManager.loadCachedRecipes()
        if !cachedRecipes.isEmpty {
            recipes = cachedRecipes
        }
    }

    private func mergeRecipes(_ newRecipes: [Recipe]) async -> [Recipe] {
        let cachedRecipes = await cacheManager.loadCachedRecipes()
        return merge(newRecipes: newRecipes, with: cachedRecipes)
    }

    private func merge(newRecipes: [Recipe], with existing: [Recipe]) -> [Recipe] {
        var merged = existing
        for recipe in newRecipes {
            if let index = merged.firstIndex(where: { $0.id == recipe.id }) {
                // Update existing recipe and check for image changes
                let oldRecipe = merged[index]
                merged[index] = recipe
                if oldRecipe.photoURLSmall != recipe.photoURLSmall {
                    cacheManager.clearImageCache(for: recipe.id)
                }
            } else {
                merged.append(recipe)
            }
        }
        return merged
    }

    // MARK: - Error Handling
    private func handleError(_ error: RecipeError) {
        self.error = error
        if recipes.isEmpty {
            recipes = []
        }
    }
}

// MARK: - Error Types
enum RecipeError: Error, LocalizedError {
    case invalidData
    case serverError(Int)
    case parsingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidData: return "Invalid recipe data received"
        case .serverError(let code): return "Server error: \(code)"
        case .parsingFailed: return "Failed to parse recipes"
        case .unknown(let error): return error.localizedDescription
        }
    }
}
