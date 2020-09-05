//
//  SearchBar.swift
//  Gemu
//
//  Created by Renan Maganha on 27/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    var viewModel: GemuViewModel
    @Binding var search: String
    @State var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $search) {
                self.viewModel.getGameList(gameName: self.search)
            }.onTapGesture {
                self.isEditing = true
            }
            
            if isEditing {
                Button(action: {
                    self.search = ""
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                })
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.black.opacity(0.07))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
