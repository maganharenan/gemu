//
//  HomeView.swift
//  Gemu - Collection Game Tracker
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GemuViewModel
    @State var selection = 3
    @State var search = ""
    @State var isShowingGameDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.currentView == .collection {
                    CollectionView(viewModel: viewModel, showDetail: $isShowingGameDetails)
                } else if viewModel.currentView == .profile {
                    ProfileView(viewModel: viewModel, showDetail: $isShowingGameDetails)
                } else if viewModel.currentView == .wishlist {
                    WishlistView(viewModel: viewModel, showDetail: $isShowingGameDetails)
                }
                
                TabBar(viewModel: viewModel, tabItensResource: SystemResources().tabBarItems)
                    .offset(y: isShowingGameDetails ? 50 : 0)
                    .animation(.linear)
            }
            
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: GemuViewModel())
    }
}

