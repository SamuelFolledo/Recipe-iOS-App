//
//  RecipeListViewModel.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

final class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
}
