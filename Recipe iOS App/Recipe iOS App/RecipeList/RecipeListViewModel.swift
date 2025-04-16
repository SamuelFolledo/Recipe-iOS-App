//
//  RecipeListViewModel.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: RecipeError?
    @Published var selectedRecipe: Recipe?
    @Published var selectedEndpoint: Endpoint = .allRecipes

    private let recipeService: RecipeServiceProtocol
    private let cacheManager: CacheManagerProtocol

    init(recipeService: RecipeServiceProtocol = RecipeService(), cacheManager: CacheManagerProtocol = CacheManager.shared) {
        self.recipeService = recipeService
        self.cacheManager = cacheManager
    }

    func endpointChangedHandler() {
        recipes.removeAll()
        Task {
            await loadRecipes()
        }
    }

    func loadRecipes() async {
        error = nil
        isLoading = true
        do {
            await loadCachedRecipes()
            let newRecipes = try await recipeService.fetchRecipes(selectedEndpoint)
            let mergedRecipes = await mergeRecipes(newRecipes)
            recipes = mergedRecipes
            await cacheManager.cacheRecipes(mergedRecipes, to: selectedEndpoint)
        } catch let error as RecipeError {
            handleError(error)
        } catch {
            handleError(.unknown(error))
        }
        isLoading = false
    }
}

private extension RecipeListViewModel {
    func loadCachedRecipes() async {
        let cached = await cacheManager.loadCachedRecipes(from: selectedEndpoint)
        if !cached.isEmpty {
            recipes = cached
        }
    }

    func mergeRecipes(_ newRecipes: [Recipe]) async -> [Recipe] {
        var merged = recipes
        for recipe in newRecipes {
            if let index = merged.firstIndex(where: { $0.id == recipe.id }) {
                let oldRecipe = merged[index]
                merged[index] = recipe
                if oldRecipe.photoURLSmall != recipe.photoURLSmall {
                    await cacheManager.clearImageCache(forKey: recipe.id)
                }
            } else {
                merged.append(recipe)
            }
        }
        return merged
    }

    func handleError(_ error: RecipeError) {
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
