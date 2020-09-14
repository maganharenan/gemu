//
//  ProfileView.swift
//  Gemu - Collection Game Tracker
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @ObservedObject var viewModel: GemuViewModel
    @State var segmentControllSelection = 0
    @State var showConfiguration = false
    @Binding var showDetail: Bool
    @State var currentSelectedGame = Game()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    BadgeView(viewModel: viewModel)
                        .frame(width: 50, height: 50)
                        .padding()
                    
                    Text(UserDefaults.standard.string(forKey: "username") ?? "User")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding([.vertical, .trailing])
                    
                    Spacer()
                    
                    Button(action: {
                        self.showConfiguration.toggle()
                    }, label: {
                        Image(systemName: "gear")
                        .foregroundColor(Color("DefaultButton"))
                            .padding()
                    })
                    
                }
                .onAppear {
                    self.viewModel.fetchAllGameData()
                    self.viewModel.fetchPlatformData()
                }
                
                gameStatusInformation
                    .padding(.horizontal)
                
                Picker(selection: $segmentControllSelection, label: Text("Category Picker")) {
                    ForEach(0..<SystemResources().profileSegmentLabels.count) { index in
                        Text(SystemResources().profileSegmentLabels[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ZStack {
                    
                    if !viewModel.viewIsRefreshing {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(self.viewModel.fetchedResultsPlatforms.fetchedObjects?.filter{ gamesForSelectedCategory(platform: $0) } ?? [], id: \.self) { platform in
                                HorizontalGameCollection(viewModel: self.viewModel, platform: platform, list: SystemResources().profileSegmentLabels[self.segmentControllSelection], currentSelectedGame: self.$currentSelectedGame, showDetail: self.$showDetail)
                            }
                            .padding(.bottom, 66)
                        }
                    }
                    
                    NavigationLink(destination: SearchGameView()) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary).colorInvert()
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 100, style: .continuous).fill(Color("DefaultButton")))
                            .shadow(color: Color.black.opacity(0.5), radius: 4, x: 3, y: 3)
                            .shadow(color: Color.white.opacity(0.8), radius: 4, x: -3, y: -3)
                        
                    }
                    .padding()
                    .padding(.bottom,50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }
            .background(Color(UIColor.systemGray5).opacity(0.6).edgesIgnoringSafeArea(.all))
            .scaleEffect(showConfiguration ? 0.5 : 1)
            .blur(radius: showConfiguration ? 3 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            
            if showDetail {
                OfflineGameDetailView(game: currentSelectedGame, showDetail: $showDetail)
            }
            
            UserSettingsView(viewModel: viewModel, showSettings: $showConfiguration)
                .offset(y: showConfiguration ? .zero : UIScreen.main.bounds.size.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        }
    }
    
    @State var viewIsRefreshing = false
    
    var gameStatusInformation: some View {
        HStack {
            ForEach(0..<SystemResources().profileSegmentLabels.count) { index in
                GameCountLabel(category: SystemResources().profileSegmentLabels[index], viewModel: self.viewModel)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    func gamesForSelectedCategory(platform: Platform) -> Bool {
        switch SystemResources().profileSegmentLabels[segmentControllSelection] {
        case "Played": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform == platform) && ($0.lists?.played == true) }.count ?? 0 > 0
        case "Playing": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform == platform) && ($0.lists?.playing == true) }.count ?? 0 > 0
        case "Completed": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform == platform) && ($0.lists?.completed == true) }.count ?? 0 > 0
        default: return false
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: GemuViewModel(), showDetail: .constant(false))
    }
}

struct GameCountLabel: View {
    var category: String
    @ObservedObject var viewModel: GemuViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.viewIsRefreshing ? "..." : String(totalOfGames))
                .font(.footnote)
                .fontWeight(.bold)
            
            Text(category)
                .font(.system(size: 10))
        }
    }
    
    private var totalOfGames: Int {
        switch category {
        case "Played": return totalOfPlayedGames
        case "Playing": return totalOfPlayingGames
        case "Completed": return totalOfCompletedGames
        default: return 0
        }
    }
    
    private var totalOfPlayedGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.played == true }.count ?? 0
    }
    
    private var totalOfPlayingGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.playing == true }.count ?? 0
    }
    
    private var totalOfCompletedGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.completed == true }.count ?? 0
    }
    
    private func refresh() {
        self.viewModel.viewIsRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewModel.viewIsRefreshing = false
        }
    }
}

struct HorizontalGameCollection: View {
    var viewModel: GemuViewModel
    var platform: Platform
    var list: String
    @Binding var currentSelectedGame: Game
    @Binding var showDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(platform.name ?? "")
                .padding([.horizontal])
            Text("\(totalOfGamesOfConsole)/\(totalOfGames) of \(list.lowercased()) games")
                .font(.caption)
                .padding([.horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(gameList.filter { ($0.platform == platform) } , id: \.self) { game in
                        GeometryReader { geometry in
                            Image(uiImage: UIImage(data: game.cover ?? Data()) ?? UIImage())
                                .interpolation(.high)
                                .resizable()
                                .padding(.vertical,5)
                                .scaledToFit()
                                .frame(width: 145, height: 254)
                                .shadow(color: Color("ProfileGameCoverShadow").opacity(0.2), radius: 5, x: 0, y: 0)
                                .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / 20), axis: (x: 0, y: 10.0, z: 0))
                                .contextMenu {
                                    Button(action: {
                                        self.viewModel.deleteGameFromDatabase(game: game)
                                    }, label: {
                                        HStack {
                                            Text("Delete").fontWeight(.thin)
                                            Image(systemName: "trash").font(.system(size: 10, weight: .thin, design: .rounded))
                                        }
                                    })
                                }
                                .onTapGesture {
                                    self.currentSelectedGame = game
                                    self.showDetail.toggle()
                                }
                        }
                            .frame(width: 145, height: 204)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var gameList: [Game] {
        switch list {
        case "Played": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.lists?.played == true) } ?? []
        case "Playing": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.lists?.playing == true) } ?? []
        case "Completed": return viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.lists?.completed == true) } ?? []
        default: return []
        }
    }
    
    private var totalOfGames: Int {
        switch list {
        case "Played": return totalOfPlayedGames
        case "Playing": return totalOfPlayingGames
        case "Completed": return totalOfCompletedGames
        default: return 0
        }
    }
    
    private var totalOfGamesOfConsole: Int {
        switch list {
        case "Played": return totalOfPlayedGamesInConsoleList
        case "Playing": return totalOfPlayingGamesInConsoleList
        case "Completed": return totalOfCompletedGamesInConsoleList
        default: return 0
        }
    }
    
    private var totalOfPlayedGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.played == true }.count ?? 0
    }
    
    private var totalOfPlayingGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.playing == true }.count ?? 0
    }
    
    private var totalOfCompletedGames: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter{ $0.lists?.completed == true }.count ?? 0
    }

    private var totalOfPlayedGamesInConsoleList: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform?.name == platform.name) && ($0.lists?.played == true) }.count ?? 0
    }
    
    private var totalOfPlayingGamesInConsoleList: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform?.name == platform.name) && ($0.lists?.playing == true) }.count ?? 0
    }
    
    private var totalOfCompletedGamesInConsoleList: Int {
        viewModel.fetchedResultsGame.fetchedObjects?.filter { ($0.platform?.name == platform.name) && ($0.lists?.completed == true) }.count ?? 0
    }
}
