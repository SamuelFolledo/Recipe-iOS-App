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
        sizeClass == .regular ?
        [GridItem(.adaptive(minimum: 300), spacing: 16)] :
        [GridItem(.flexible(), spacing: 16)]
    }

    var body: some View {
        if sizeClass == .regular {
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                listContent
            } detail: {
                detailContent
            }
            .navigationSplitViewStyle(.balanced)
        } else {
            NavigationStack {
                listContent
            }
        }
    }

    @ViewBuilder private var listContent: some View {
        Group {
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                LoadingView()
            } else if let error = viewModel.error {
                ErrorView(error: error, retryAction: {
                    Task { await viewModel.loadRecipes() }
                })
            } else if viewModel.recipes.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.sectionedFilteredAndSortedRecipes, id: \.key) { section in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.key)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                    .padding(.top, 8)

                                LazyVGrid(columns: gridColumns, spacing: 16) {
                                    ForEach(section.value) { recipe in
                                        recipeItem(recipe)
                                    }
                                }
                            }
                        }
                    }
                    .padding(8)
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search recipes")
            }
        }
        .navigationTitle(viewModel.selectedEndpoint.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                settingsButton
            }
        }
        .task { await viewModel.loadRecipes() }
        .refreshable { await viewModel.loadRecipes() }
    }

    @ViewBuilder func recipeItem(_ recipe: Recipe) -> some View {
        let isSelected = viewModel.selectedRecipe?.id == recipe.id
        Button {
            viewModel.selectedRecipe = recipe
        } label: {
            switch sizeClass {
            case .regular:
                RecipeCard(recipe: recipe, isSelected: isSelected)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 2)
                    }
            case .compact:
                RecipeCard(recipe: recipe, isSelected: isSelected)
                    .sheet(item: $viewModel.selectedRecipe) { recipe in
                        RecipeDetailView(recipe: recipe)
                    }
            default:
                EmptyView()
            }
        }
        .contentShape(Rectangle())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    @ViewBuilder private var detailContent: some View {
        if let recipe = viewModel.selectedRecipe {
            RecipeDetailView(recipe: recipe)
        } else {
            Text("Select a recipe")
                .foregroundColor(.secondary)
                .font(.title2)
        }
    }

    @ViewBuilder private var settingsButton: some View {
        Menu {
            Section(header: Text("Endpoint")) {
                ForEach(Endpoint.allCases, id: \.self) { endpoint in
                    Button {
                        viewModel.selectedEndpoint = endpoint
                        viewModel.endpointChangedHandler()
                    } label: {
                        HStack {
                            Text(endpoint.title)

                            if viewModel.selectedEndpoint == endpoint {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }

            Section(header: Text("Sort By")) {
                ForEach(RecipeSort.allCases) { sortOption in
                    Button {
                        viewModel.sort = sortOption
                    } label: {
                        HStack {
                            Text(sortOption.rawValue)

                            if viewModel.sort == sortOption {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "gearshape")
                .imageScale(.large)
                .accessibilityLabel("Settings")
        }
    }
}


// MARK: - Preview
#Preview {
    RecipeListView()
}


// MARK: - Subviews
struct RecipeCard: View {
    let recipe: Recipe
    var isSelected: Bool = false
    @State private var image: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.displayName)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.7), radius: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 2)
        )
        .task {
            await image = recipe.loadImage(isLarge: true)
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
