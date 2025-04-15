//
//  ZoomableImageView.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/15/25.
//

import SwiftUI

struct ZoomableImageView: View {
    let image: UIImage
    @Binding var isPresented: Bool

    @State private var scale: CGFloat = 1.0
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack(alignment: .center) {
            Color.black.ignoresSafeArea()

            imageView

            closeButton
        }
    }

    var imageView: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(offset.height) > 200 || abs(offset.width) > 200 { ///drag to dismiss
                            isPresented = false
                        } else {
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = .zero
                            }
                        }
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        /// Limit scale between 1x and 4x
                        scale = max(1.0, min(value.magnitude, 4.0))                     }
                    .onEnded { _ in
                        /// Reset to minimum scale of 1.0
                        withAnimation { scale = max(1.0, scale) }
                    }
            )
    }

    var closeButton: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                .accessibilityLabel("Close")
                .accessibilityHint("Dismiss the full-screen image view")
            }

            Spacer()
        }
    }
}
