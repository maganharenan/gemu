//
//  Endpoints.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

enum Endpoints {
    static let apiKey = "299628a7a8241a517939bfaee352eb9c"
    static let baseURL = "https://api-v3.igdb.com/"
    
    case game(String)
    case covers(String)
    case platforms(String)
    case genres(String)
    case companies(String)
    case platformLogos(Int)
    
    var stringValue: String {
        switch self {
        case .game: return Endpoints.baseURL + "games"
        case .covers: return Endpoints.baseURL + "covers"
        case .platforms: return Endpoints.baseURL + "platforms"
        case .genres: return Endpoints.baseURL + "genres"
        case .companies: return Endpoints.baseURL + "companies"
        case .platformLogos: return Endpoints.baseURL + "platform_logos"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
    var bodyResource: Data {
        switch self {
        case .game(let gameName): return "search \"\(gameName)\";  fields age_ratings,aggregated_rating,aggregated_rating_count,artworks,category,checksum,collection,cover,first_release_date,genres,involved_companies,name,platforms,rating,rating_count,screenshots,status,storyline,summary;".data(using: .utf8, allowLossyConversion: false)!
        case .covers(let id): return "fields height,image_id,url,width; where id = \(id);".data(using: .utf8, allowLossyConversion: false)!
        case .platforms(let id): return "fields abbreviation,alternative_name,category,checksum,created_at,generation,name,platform_logo,product_family,slug,summary,updated_at,url,versions,websites; where id = \(id);".data(using: .utf8, allowLossyConversion: false)!
        case .genres(let id): return "fields name; where id = \(id);".data(using: .utf8, allowLossyConversion: false)!
        case .companies(let id): return "fields description,logo,name; where id = \(id);".data(using: .utf8, allowLossyConversion: false)!
        case .platformLogos(let logoId): return "fields height,image_id,url,width; where id = \(logoId);".data(using: .utf8, allowLossyConversion: false)!
        }
    }
}


