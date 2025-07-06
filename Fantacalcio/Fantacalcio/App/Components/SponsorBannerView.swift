//
//  SponsorBannerView.swift
//  Fantacalcio
//
//  Created by Giuseppe Carannante on 06/07/2025.
//

import SwiftUI

struct SponsorNavigationView<Content: View>: View {
    let currentSection: MainRoot
    let bannerImageUrl: URL?
    let tapAction: (() -> Void)?
    let bannerHeight: CGFloat
    let content: Content

    private var fallbackImage: Image {
        switch currentSection {
            case .favourites:
                return Image("Fav-Default")
            case .dashboard:
                return Image("List-Default")
            default:
                return Image("List-Default")
        }
    }

    init(
        currentSection: MainRoot = .dashboard,
        bannerImageUrl: URL?,
        tapAction: (() -> Void)? = nil,
        bannerHeight: CGFloat = 200,
        @ViewBuilder content: () -> Content
    ) {
        self.currentSection = currentSection
        self.bannerImageUrl = bannerImageUrl
        self.tapAction = tapAction
        self.bannerHeight = bannerHeight
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
                AsyncImage(url: bannerImageUrl) { phase in
                    switch phase {
                    case .empty:
                        fallbackImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                            .clipped()
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
                        fallbackImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    @unknown default:
                        fallbackImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: bannerHeight)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                }
                .padding(.bottom, 16)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(edges: .top)
    }
}
