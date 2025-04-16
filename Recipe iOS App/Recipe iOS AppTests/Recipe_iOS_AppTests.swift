//
//  Recipe_iOS_AppTests.swift
//  Recipe iOS AppTests
//
//  Created by Samuel Folledo on 4/14/25.
//

// CacheManagerTests.swift
import Testing
@testable import Recipe_iOS_App

struct RecipeListViewModelTests {
    @MainActor
    @Test func testInitialLoadSetsFirstRecipe() async {
        let viewModel = RecipeListViewModel(recipeService: MockRecipeService())
        await viewModel.loadRecipes()
        #expect(!viewModel.recipes.isEmpty)
        #expect(viewModel.recipes.count < 1000)
    }

    @MainActor
    @Test func testChangeEndpointReloadsData() async {
        let viewModel = RecipeListViewModel(recipeService: MockRecipeService())
        await viewModel.loadRecipes()
        let initialCount = viewModel.recipes.count
        await MainActor.run {
            viewModel.selectedEndpoint = .empty
        }
        viewModel.endpointChangedHandler()
        #expect(viewModel.recipes.count != initialCount)
    }

}

// MARK: - Test Mocks
struct MockRecipeService: RecipeServiceProtocol {
    func fetchRecipes(_ endpoint: Endpoint) async throws -> [Recipe] {
        endpoint == .empty ? [] : [fakeRecipe]
    }
}
