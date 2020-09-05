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
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.currentView == .collection {
                    CollectionView()
                } else if viewModel.currentView == .profile {
                    ProfileView()
                } else if viewModel.currentView == .wishlist {
                    WishlistView()
                }
                
                TabBar(viewModel: viewModel, tabItensResource: SystemResources().tabBarItems)
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

