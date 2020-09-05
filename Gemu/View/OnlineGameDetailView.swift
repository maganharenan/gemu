//
//  OnlineGameDetailView.swift
//  Gemu
//
//  Created by Renan Maganha on 30/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct OnlineGameDetailView: View {
    var viewModel: GemuViewModel
    var game: GameResponse
    var cover: String
    var platforms: [PlatformResponse]
    @State var genres: [GenreResponse] = []
    @State var companies: [CompanyResponse] = []
    @State var showPercent = false
    @State var showConfiguration = false
    
    var body: some View {
        ZStack(alignment: .top) {
            //MARK: - Game Image
            if cover != "" && cover != "https:" {
                WebImage(url: URL(string: cover.replacingOccurrences(of: "t_thumb", with: "t_720p")))
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .onAppear { self.showPercent = true }
                
            } else {
                Image("notfound")
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .onAppear { self.showPercent = true }
            }
            
            //MARK: - Configure game to save
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    self.showConfiguration.toggle()
                }, label: {
                    Text(showConfiguration ? "Cancelar" : "Adicionar jogo")
                        .frame(width: 150, height: 30)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                        .shadow(color: showConfiguration ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 4, x: -4, y: -4)
                        .shadow(color: showConfiguration ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 4, x: 4, y: 4)
                })
                .frame(maxWidth: .infinity)
                .padding()
                
                if platforms.count > 0 {
                    Text("Platform: \(platforms[selectedPlatform].name ?? "")")
                        .padding()
                        .onTapGesture {
                            withAnimation(.linear) {
                                self.showPlatforPicker.toggle()
                            }
                        }
                }
                
                if showPlatforPicker {
                    Picker(selection: $selectedPlatform, label: Text("")) {
                        ForEach(0..<platforms.count) {
                            Text(self.platforms[$0].name ?? "")
                        }
                    }
                    .labelsHidden()
                    .padding(.horizontal)
                }
                
                SwitchToggle(customSwitchActive: $addToWishlist, title:
                    "Wishlist", subtitle: "")
                    .onTapGesture { self.addToWishlist.toggle() }
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                SwitchToggle(customSwitchActive: $addToCollection, title:
                "Collection", subtitle: "")
                    .onTapGesture { self.addToCollection.toggle() }
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                SwitchToggle(customSwitchActive: $addToPlayedList, title:
                    "Played", subtitle: "")
                    .onTapGesture {
                        if self.addToPlayedList == true && self.addToPlayingList == true || self.addToPlayedList == true && self.addToCompletedList == true {
                            self.addToPlayedList = false
                            self.addToPlayingList = false
                            self.addToCompletedList = false
                        } else {
                            self.addToPlayedList.toggle()
                        }
                    }
                .padding(.horizontal)
                .padding(.top, 10)
                
                SwitchToggle(customSwitchActive: $addToPlayingList, title:
                "Playing", subtitle: "")
                    .onTapGesture {
                        if self.addToPlayingList == false && self.addToPlayedList == false {
                            self.addToPlayingList = true
                            self.addToPlayedList = true
                        } else {
                            self.addToPlayingList.toggle()
                        }
                    }
                .padding(.horizontal)
                .padding(.top, 10)
                
                SwitchToggle(customSwitchActive: $addToCompletedList, title:
                "Completed", subtitle: "")
                    .onTapGesture {
                        if self.addToCompletedList == false && self.addToPlayedList == false {
                            self.addToCompletedList = true
                            self.addToPlayedList = true
                        } else {
                            self.addToCompletedList.toggle()
                        }
                    }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
            .clipShape(RoundedCorner(radius: 15, corners: [.topLeft, .topRight]))
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: -10)
            .offset(y: showConfiguration ? 0 : 450)
            .offset(y: viewState.height)
            .scaleEffect(showConfiguration ? 1 : 0.9)
            .animation(Animation.easeIn(duration: showConfiguration ? 0.3 : 0.5))
            
            //MARK: - Information ScrollView
            
            VStack(alignment: .leading, spacing: 0) {
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(.secondary)
                    .frame(width: 80, height: 5)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .gesture(moveInformationGesture())
                
                ScrollView {
                    HStack {
                        VStack {
                            Text(game.name!)
                                .font(.body)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Company: \(listAllCompanyNames())")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                            
                            Text("Genre: \(listAllGenreNames())")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                        }
                        
                        VStack {
                            RingView(width: 50, height: 50, percent: CGFloat(game.rating ?? 0), show: $showPercent)
                            Text("Based on \(String(game.ratingCount ?? 0)) member ratings")
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                                .padding(2)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Platforms: \(listAllPlatformNames())")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text(game.summary ?? "")
                            .padding(.top)
                        
                        if game.storyline != nil {
                            Text("Storyline")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical)
                            
                            Text(game.storyline ?? "")
                                .padding(.top)
                        }
                    }
                    .padding()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
            .clipShape(RoundedCorner(radius: 15, corners: [.topLeft, .topRight]))
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: -10)
            .offset(y: showConfiguration ? screenSize.height : 490)
            .offset(y: viewState.height)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        }
        .onAppear { self.fetchGameInformation() }
    }
    
    var screenSize = UIScreen.main.bounds
    
    //MARK: - Game configuration
    
    @State var showPlatforPicker = false
    
    @State var selectedPlatform = 0
    @State var addToWishlist = false
    @State var addToCollection = false
    @State var addToPlayedList = false
    @State var addToPlayingList = false
    @State var addToCompletedList = false
    
    //MARK: - Gestures
    
    @State var viewState = CGSize.zero
    
    private func moveInformationGesture() -> some Gesture {
        DragGesture()
            .onChanged{ value in
                self.viewState.height = value.translation.height
            }
            .onEnded{ value in
                if value.translation.height < -50 {
                    self.viewState.height = -400
                } else {
                    self.viewState.height = .zero
                }
            }
    }
    
    //MARK: - Methods
    
    private func listAllPlatformNames() -> String {
        var platformsList: String {
            var valuesList = ""
            for platform in platforms {
                valuesList += platform.name ?? ""
                valuesList += platform == platforms.last ? "." : ", "
            }
            return valuesList
        }
        return platformsList
    }
    
    private func listAllGenreNames() -> String {
        var genresList: String {
            var valuesList = ""
            for genre in genres {
                valuesList += genre.name ?? ""
                valuesList += genre == genres.last ? "." : ", "
            }
            return valuesList
        }
        return genresList
    }
    
    private func listAllCompanyNames() -> String {
        var companiesList: String {
            var valuesList = ""
            for company in companies {
                valuesList += company.name ?? ""
                valuesList += company == companies.last ? "." : ", "
            }
            return valuesList
        }
        return companiesList
    }
    
    private func fetchGameInformation() {
        viewModel.getAllGenresForTheGame(genreIds: game.genres ?? []) { (response) in
            self.genres = response
        }
        viewModel.getCompanyInformation(companyIds: game.involvedCompanies ?? []) { (response) in
            self.companies = response
        }
    }
}

