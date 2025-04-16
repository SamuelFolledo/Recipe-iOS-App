//
//  Endpoint.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

enum Endpoint: CaseIterable {
    case allRecipes, malformed, empty

    var urlString: String {
        switch self {
        case .allRecipes: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case .malformed: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case .empty: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        }
    }

    var title: String {
        switch self {
        case .allRecipes: "All Recipes"
        case .malformed: "Malformed JSON"
        case .empty: "Empty JSON"
        }
    }

    var urlRequest: URLRequest? {
        URL(string: urlString).map {
            URLRequest(url: $0)
        }
    }

    var cacheKey: String {
        switch self {
        case .allRecipes: "allRecipes"
        case .malformed: "malformed"
        case .empty: "empty"
        }
    }
}

enum ImageSize {
    case small, large
}
