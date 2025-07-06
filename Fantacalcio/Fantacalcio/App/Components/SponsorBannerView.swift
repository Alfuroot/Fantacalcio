//
//  SponsorBannerView.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//

import SwiftUI

struct SponsorNavigationView<Content: View>: View {
    let bannerImageUrl: URL?
    let tapAction: (() -> Void)?
    let bannerHeight: CGFloat
    let content: Content

    init(
        bannerImageUrl: URL?,
        tapAction: (() -> Void)? = nil,
        bannerHeight: CGFloat = 200,
        @ViewBuilder content: () -> Content
    ) {
        self.bannerImageUrl = bannerImageUrl
        self.tapAction = tapAction
        self.bannerHeight = bannerHeight
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = bannerImageUrl {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .onTapGesture {
                                tapAction?()
                            }
                    case .failure:
                        Color.gray
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        Color.gray
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 16)
            } else {
                Color.gray
                    .frame(height: bannerHeight)
                    .frame(maxWidth: .infinity)
            }

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(edges: .top)
    }
}
