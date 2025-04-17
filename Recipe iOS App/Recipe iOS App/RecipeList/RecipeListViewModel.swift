//
//  RecipeListViewModel.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {
    private let recipeService: RecipeServiceProtocol
    private let cacheManager: CacheManagerProtocol

    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: RecipeError?
    @Published var selectedRecipe: Recipe?
    @Published var selectedEndpoint: Endpoint = .allRecipes
    @Published var searchText: String = ""
    @Published var sort: RecipeSort = .nameAsc

    var sectionKey: (Recipe) -> String {
        switch sort {
        case .nameAsc, .nameDesc:
            return { recipe in
                recipe.displayName.first.map { String($0).uppercased() } ?? "#"
            }
        case .cuisineAsc, .cuisineDesc:
            return { recipe in recipe.cuisine }
        }
    }
    var filteredAndSortedRecipes: [Recipe] {
        let filtered = searchText.isEmpty
        ? recipes
        : recipes.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText)
            || $0.cuisine.localizedCaseInsensitiveContains(searchText)
        }
        switch sort {
        case .nameAsc:
            return filtered.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        case .nameDesc:
            return filtered.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedDescending }
        case .cuisineAsc:
            return filtered.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        case .cuisineDesc:
            return filtered.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedDescending }
        }
    }
    var sectionedFilteredAndSortedRecipes: [(key: String, value: [Recipe])] {
        let grouped = Dictionary(grouping: filteredAndSortedRecipes, by: sectionKey)
        switch sort {
        case .nameAsc:
            return grouped.sorted { $0.key.localizedCompare($1.key) == .orderedAscending }
        case .nameDesc:
            return grouped.sorted { $0.key.localizedCompare($1.key) == .orderedDescending }
        case .cuisineAsc:
            return grouped.sorted { $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending }
        case .cuisineDesc:
            return grouped.sorted { $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedDescending }
        }
    }

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
