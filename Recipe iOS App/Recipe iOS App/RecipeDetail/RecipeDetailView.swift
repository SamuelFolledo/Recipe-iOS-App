//
//  RecipeDetailView.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    let recipe: Recipe
    @State private var image: UIImage?
    @State private var showFullImage = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageSection

                VStack(alignment: .leading, spacing: 8) {
                    if sizeClass == .compact {
                        Text(recipe.displayName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    Text(recipe.cuisine)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                linksSection
            }
            .padding()
        }
        .navigationTitle(recipe.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: recipe) { _, newValue in
            Task {
                await image = newValue.loadImage(isLarge: true)
            }
        }
        .task {
            await image = recipe.loadImage(isLarge: true)
        }
        .fullScreenCover(isPresented: $showFullImage) {
            if let image = image {
                ZoomableImageView(image: image, isPresented: $showFullImage)
            }
        }
    }

    private var imageSection: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, maxHeight: sizeClass == .regular ? 200 : nil)
                    .onTapGesture {
                        showFullImage = true
                    }
            } else {
                ProgressView()
                    .frame(height: 300)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var linksSection: some View {
        VStack(spacing: 16) {
            if let sourceURL = recipe.sourceURL {
                Link(destination: sourceURL) {
                    HStack {
                        Image(systemName: "globe")
                        Text("View Original Recipe")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            if let youtubeURL = recipe.youtubeURL {
                Link(destination: youtubeURL) {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                        Text("Watch on YouTube")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
    }
}

#Preview {
    RecipeDetailView(recipe: fakeRecipe)
}
