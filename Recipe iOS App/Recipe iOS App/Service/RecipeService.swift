//
//  RecipeService.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(_ endpoint: Endpoint) async throws -> [Recipe]
}

class RecipeService {
    private let networkService: NetworkService

    init(networkService: NetworkService = APIClient()) {
        self.networkService = networkService
    }
}

extension RecipeService: RecipeServiceProtocol {
    func fetchRecipes(_ endpoint: Endpoint) async throws -> [Recipe] {
        guard let request = endpoint.urlRequest else {
            throw APIError.invalidURL
        }
        let wrapper: RecipeWrapper = try await networkService.fetch(request)
        return wrapper.recipes.filter { $0.isValid }
    }
}
