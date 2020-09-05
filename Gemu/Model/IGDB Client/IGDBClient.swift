//
//  IGDBClient.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

class IGDBClient {
    func getGameList(gameName: String, completion: @escaping ([GameResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.game("").url, responseType: [GameResponse].self, body: Endpoints.game(gameName).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getCoverImage(gameId: String, completion: @escaping ([CoverResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.covers("").url, responseType: [CoverResponse].self, body: Endpoints.covers(gameId).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getPlatformInformation(gameId: String, completion: @escaping ([PlatformResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.platforms("").url, responseType: [PlatformResponse].self, body: Endpoints.platforms(gameId).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getGameGenre(genreId: Int, completion: @escaping ([GenreResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.genres("").url, responseType: [GenreResponse].self, body: Endpoints.genres(String(genreId)).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getCompanyInformation(companyId: Int, completion: @escaping ([CompanyResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.companies("").url, responseType: [CompanyResponse].self, body: Endpoints.companies(String(companyId)).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getPlatformLogo(logoId: Int, completion: @escaping ([PlatformLogoResponse]?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.platformLogos(0).url, responseType: [PlatformLogoResponse].self, body: Endpoints.platformLogos(logoId).bodyResource) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
