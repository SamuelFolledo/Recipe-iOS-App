//
//  RecipeDetailView.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        Text(recipe.name)
            .font(.largeTitle)
    }
}

#Preview {
    RecipeDetailView(recipe: fakeRecipe)
}
