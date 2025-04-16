//
//  RecipeService.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

class RecipeService {
    private let networkService: NetworkService

    init(networkService: NetworkService = APIClient()) {
        self.networkService = networkService
    }
}

extension RecipeService: RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe] {
        guard let request = Endpoint.allRecipes.urlRequest else {
            throw APIError.invalidURL
        }
        let wrapper: RecipeWrapper = try await networkService.fetch(request)
        // Validate all recipes
        guard wrapper.recipes.allSatisfy(\.isValid) else {
            throw APIError.invalidResponse
        }
        return wrapper.recipes
    }
}
