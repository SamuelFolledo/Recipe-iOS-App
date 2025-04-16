//
//  RecipeServiceTests.swift
//  Recipe iOS AppTests
//
//  Created by Samuel Folledo on 4/16/25.
//

import Foundation
import Testing
@testable import Recipe_iOS_App

struct RecipeServiceTests {
    @Test("Testing recipe fetch from all endpoints",
          arguments: Endpoint.allCases)
    func testFetchRecipesReturnsValidData(endpoint: Endpoint) async throws {
        let service = RecipeService(networkService: MockNetworkService(endpoint: endpoint))
        let recipes = try await service.fetchRecipes(endpoint)
        switch endpoint {
        case .allRecipes:
            #expect(!recipes.isEmpty)
            #expect(recipes.allSatisfy { $0.isValid })
        case .malformed:
            #expect(!recipes.isEmpty)
            #expect(!recipes.filter { $0.isValid }.isEmpty)
        case .empty:
            #expect(recipes.isEmpty)
        }
    }
}

struct MockNetworkService: NetworkService {
    let endpoint: Endpoint

    func fetch<T: Decodable>(_ request: URLRequest) async throws -> T {
        let dummyRecipes = endpoint == .empty ? [] : [fakeRecipe]
        let wrapper = RecipeWrapper(recipes: dummyRecipes)
        return wrapper as! T
    }
}
