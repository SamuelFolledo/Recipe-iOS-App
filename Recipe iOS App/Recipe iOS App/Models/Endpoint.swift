//
//  Endpoint.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

enum Endpoint {
    static var allRecipes: URLRequest? {
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json").map {
            URLRequest(url: $0)
        }
    }
}

enum ImageSize {
    case small, large
}
