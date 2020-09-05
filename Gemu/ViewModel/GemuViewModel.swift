//
//  GemuViewModel.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

class GemuViewModel: ObservableObject {
    @Published var currentView: SystemResources.Views = .profile
    @Published var gamesList: [GameResponse] = []
    
    func getGameList(gameName: String) {
        IGDBClient().getGameList(gameName: gameName) { (response, error) in
            if let response = response {
                self.gamesList = response
            }
        }
    }
    
    //MARK: - Game Information Methods
    
    func getGameCoverImage(gameId: String, completion: @escaping (String?) -> Void) {
        IGDBClient().getCoverImage(gameId: gameId) { (response, error) in
            if let response = response {
                completion("https:\(response.first?.url ?? "")")
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func getAllPlatformsInformations(platforms: [Int], completion: @escaping ([PlatformResponse]) -> Void) {
        var allPlatformInformation: [PlatformResponse] = []

        for platform in platforms {
            getPlatformInformation(gameId: String(platform)) { (response, error) in
                if let response = response {
                    allPlatformInformation.append(response.first!)
                    completion(allPlatformInformation)
                }
            }
        }
    }
    
    func getPlatformInformation(gameId: String, completion: @escaping ([PlatformResponse]?, Error?) -> Void) {
        IGDBClient().getPlatformInformation(gameId: gameId) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func getAllGenresForTheGame(genreIds: [Int], completion: @escaping ([GenreResponse]) -> Void) {
        var genresList: [GenreResponse] = []
        for id in genreIds {
            IGDBClient().getGameGenre(genreId: id) { (response, error) in
                if let response = response {
                    genresList.append(response.first!)
                    completion(genresList)
                } else {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func getCompanyInformation(companyIds: [Int], completion: @escaping ([CompanyResponse]) -> Void) {
        var companiesList: [CompanyResponse] = []
        for id in companyIds {
            IGDBClient().getCompanyInformation(companyId: id) { (response, error) in
                if let response = response {
                    if response != [] {
                        companiesList.append(response.first!)
                        completion(companiesList)
                    }
                } else {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func getPlatformLogoImage(logoId: Int, completion: @escaping (String?) -> Void) {
        IGDBClient().getPlatformLogo(logoId: logoId) { (response, error) in
            if let response = response {
                completion("https:\(response.first?.url ?? "")")
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
