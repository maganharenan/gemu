//
//  CollectionView.swift
//  Gemu
//
//  Created by Renan Maganha on 28/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: GemuViewModel
    @State var search:String = ""
    @Binding var showDetail: Bool
    @State var currentSelectedGame = Game()

    var body: some View {
        ZStack {
            VStack {
                SearchBar(viewModel: viewModel, search: $search)
                
                List {
                    ForEach(viewModel.fetchedResultsGame.fetchedObjects?.filter { search != "" ? $0.name?.lowercased().contains(search.lowercased()) ?? false && ($0.lists?.collection == true) : ($0.lists?.collection == true) } ?? [], id: \.self) { game in
                        GameCard(currentSelectedGame: self.$currentSelectedGame, showDetail: self.$showDetail, game: game)
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
                    }
                    Rectangle().fill(Color.clear).frame(height: 60)
                }
                .onAppear {
                    self.viewModel.fetchAllGameData()
                    self.viewModel.fetchPlatformData()
                }
            }
            .background(Color(UIColor.systemGray5).opacity(0.6).edgesIgnoringSafeArea(.all))
            .blur(radius: showDetail ? 4 : 0)
            
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
            
            if showDetail {
                OfflineGameDetailView(game: currentSelectedGame, showDetail: $showDetail)
            }
        }
    }

    init(viewModel: GemuViewModel, showDetail: Binding<Bool>) {
        self._showDetail = showDetail
        self.viewModel = viewModel
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(viewModel: GemuViewModel(), showDetail: .constant(false))
    }
}
