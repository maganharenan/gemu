//
//  GameSearchResultCard.swift
//  Gemu
//
//  Created by Renan Maganha on 28/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct GameSearchResultCard: View {
    var viewModel: GemuViewModel
    var game: GameResponse
    @State var scale: CGFloat = 0.75
    @State var coverImageURL = ""
    @State var platformImageURL = ""
    @State var platform: [PlatformResponse] = []
    @State var imageWasSearched = false
    @State var showPercent = false
    @State var showDetail = false
    
    var body: some View {
        HStack(alignment: .top, spacing:10) {
            ZStack {
                if !imageWasSearched {
                LottieView(fileName: "loading")
                    .frame(width: 85, height: 85)
                    .onAppear{
                        self.viewModel.getGameCoverImage(gameId: String(self.game.cover ?? 0)) { (url) in
                            self.coverImageURL = url ?? ""
                            self.imageWasSearched = true
                        }
                        self.viewModel.getAllPlatformsInformations(platforms: self.game.platforms ?? []) { (response) in
                            self.platform = response
                            self.getTheLogoForPlatform(logoId: self.platform.first?.platformLogo ?? 99999)
                        }
                    }
                }
            
                if imageWasSearched {
                    if coverImageURL != "" && coverImageURL != "https:" {
                        WebImage(url: URL(string: coverImageURL))
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 85)

                    } else {
                        Image("notfound")
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 85)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(game.name ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.top, 2)
                    .lineLimit(2)
                
                Text(game.gameCategory)
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .center, spacing: 4) {
                    //MARK: - Members rating
                    RingView(width: 30, height: 30, percent: CGFloat(game.rating ?? 0), show: $showPercent)
                        .onAppear { self.showPercent = true }
                    
                    Text("Based on \(String(game.ratingCount ?? 0)) member ratings")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 100)
                    
                    Spacer()
                    
                    if platformImageURL != "" && platformImageURL != "https:" {
                        WebImage(url: URL(string: platformImageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 35)
                            .cornerRadius(5)
                    }
                    
                    if platform.count > 1 {
                        Text("+\(platform.count - 1) ")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 6)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 10)
        }
        .background(Color("GameCard"))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.white.opacity(0.2), radius: 2, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
        .onTapGesture {
            self.showDetail.toggle()
        }
        .sheet(isPresented: $showDetail) {
            OnlineGameDetailView(viewModel: self.viewModel, game: self.game, cover: self.coverImageURL, platforms: self.platform)
        }
    }
    
    private func getTheLogoForPlatform(logoId: Int) {
        self.viewModel.getPlatformLogoImage(logoId: logoId) { (url) in
            self.platformImageURL = url ?? ""
        }
    }
}
