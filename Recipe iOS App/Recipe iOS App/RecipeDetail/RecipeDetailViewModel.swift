//
//  RecipeDetailViewModel.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

final class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
