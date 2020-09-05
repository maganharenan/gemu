//
//  SearchGameView.swift
//  Gemu
//
//  Created by Renan Maganha on 27/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct SearchGameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GemuViewModel()
    @State var search = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.viewModel.gamesList = []
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.pink)
                })
                    .padding([.leading, .vertical])
                
                SearchBar(viewModel: viewModel, search: $search)
                
            }
            .padding(.top)
            
            List {
                ForEach(viewModel.gamesList, id: \.self) { game in
                    GameSearchResultCard(viewModel: self.viewModel, game: game)
                }
            }
                
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            
        }
        .background(Color(UIColor.systemGray5).opacity(0.6).edgesIgnoringSafeArea(.all))
    }
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

struct SearchGameView_Previews: PreviewProvider {
    static var previews: some View {
        SearchGameView()
    }
}
