//
//  RecipeSort.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/17/25.
//

import Foundation

enum RecipeSort: String, CaseIterable, Identifiable {
    case nameAsc = "Name (A–Z)"
    case nameDesc = "Name (Z–A)"
    case cuisineAsc = "Cuisine (A–Z)"
    case cuisineDesc = "Cuisine (Z–A)"

    var id: String { rawValue }
}
