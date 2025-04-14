//
//  RecipeDetailView.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var vm: RecipeDetailViewModel

    var body: some View {

    }

    @ViewBuilder var sampleView: some View {

    }
}

#Preview {
    RecipeDetailView(vm: RecipeDetailViewModel(recipe: Recipe()))
}
