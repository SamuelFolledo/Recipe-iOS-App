//
//  RecipeListView.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var gridColumns: [GridItem] {
        if sizeClass == .regular {
            // iPad layout
            return [GridItem(.adaptive(minimum: 300), spacing: 16)]
        } else {
            // iPhone layout
            return [GridItem(.flexible())]
        }
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                LoadingView()
            } else if let error = viewModel.error {
                ErrorView(error: error, retryAction: reload)
            } else if viewModel.recipes.isEmpty {
                EmptyStateView()
            } else {
                recipesView
            }
        }
        .navigationTitle("Recipes")
        .task {
            loadInitialData()
        }
        .refreshable {
            reload()
        }
    }

    // MARK: - Subviews
    private var recipesView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(viewModel.recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(vm: RecipeDetailViewModel(recipe: recipe))
                    } label: {
                        RecipeCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    // MARK: - Actions
    private func loadInitialData() {
        Task { await viewModel.loadRecipes() }
    }

    private func reload() {
        Task { await viewModel.loadRecipes() }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RecipeListView()
    }
}


// MARK: - Subviews
struct RecipeCard: View {
    let recipe: Recipe
    @State private var image: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            imageSection
            textSection
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .task { await loadImage() }
    }

    private var imageSection: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.secondarySystemBackground)
                    .overlay(ProgressView())
            }
        }
        .frame(height: 150)
        .clipped()
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)

            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(8)
    }

    private func loadImage() async {
        guard let url = recipe.photoURLSmall else { return }
        image = await loadImage(from: url)
    }

    private func loadImage(from url: URL) async -> UIImage? {
        let cacheKey = recipe.id.uuidString
        if let cached = await CacheManager.shared.cachedImage(forKey: cacheKey) {
            return cached
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            await CacheManager.shared.cacheImage(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading Recipes...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let error: RecipeError
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)

            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.largeTitle)

            Text("No Recipes Available")
                .font(.title3)
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
