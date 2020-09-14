//
//  UserSettingsView.swift
//  Gemu
//
//  Created by Renan Maganha on 12/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct UserSettingsView: View {
    var viewModel: GemuViewModel
    @State var name = UserDefaults.standard.string(forKey: "username") ?? ""
    @Binding var showSettings: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                TextField("Username: ", text: $name) {
                    self.saveNewNameIntoUserDefaults()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .padding(.trailing, 54)
                
                Text("Favorite platform: \(getTheFavoritePlatformInformation())")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text("You have \(countGames(in: "Collection")) games in your collection.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text("You have \(countGames(in: "Wishlist")) games in your wishlist.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text("You played \(countGames(in: "Played")) games.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
            }
            
            Button(action: {
                self.showSettings.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.primary).colorInvert()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 100, style: .continuous).fill(Color("DefaultButton")))
                    .shadow(color: Color.black.opacity(0.5), radius: 4, x: 3, y: 3)
                    .shadow(color: Color.white.opacity(0.8), radius: 4, x: -3, y: -3)
            })
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(width: 300, height: 250)
        .background(Color("GameCard"))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
        .shadow(color: Color.white.opacity(0.2), radius: 5, x: -2, y: -2)
    }
    
    func saveNewNameIntoUserDefaults() {
        UserDefaults.standard.set(name, forKey: "username")
    }
    
    func getTheFavoritePlatformInformation() -> String {
        var favoritePlatform = ""
        var gamesInFavoritePlatform = 0
        let platforms = viewModel.fetchedResultsPlatforms.fetchedObjects
        for platform in platforms ?? [] {
            if let gamesCount = viewModel.fetchedResultsGame.fetchedObjects?.filter({ $0.platform?.name == platform.name }).count {
                if gamesCount > gamesInFavoritePlatform {
                    favoritePlatform = platform.name ?? "Unknow"
                    gamesInFavoritePlatform = gamesCount
                }
            }
        }
        return favoritePlatform
    }
    
    func countGames(in list: String) -> Int {
        switch list {
        case "Collection" : return viewModel.fetchedResultsGame.fetchedObjects?.filter { $0.lists?.collection == true }.count ?? 0
        case "Wishlist" : return viewModel.fetchedResultsGame.fetchedObjects?.filter { $0.lists?.wishlist == true }.count ?? 0
        case "Played": return viewModel.fetchedResultsGame.fetchedObjects?.filter { $0.lists?.played == true }.count ?? 0
        default: return 0
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(viewModel: GemuViewModel(), showSettings: .constant(true))
    }
}
