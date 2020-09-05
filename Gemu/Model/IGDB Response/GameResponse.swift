//
//  GameResponse.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct GameResponse: Codable, Hashable {
    
    var id: Int
    var ageRatings: [Int]?
    var aggregatedRating: Double?
    var aggregatedRatingCount: Int?
    var artworks: [Int]?
    var category: Int?
    var checksum: String?
    var collection: Int?
    var cover: Int?
    var firstReleaseDate: Int?
    var genres: [Int]?
    var involvedCompanies: [Int]?
    var name: String?
    var platforms: [Int]?
    var rating: Double?
    var ratingCount: Int?
    var screenshots: [Int]?
    var status: Int?
    var storyline: String?
    var summary: String?
    
    var gameCategory: String {
        return GameCategories.init(rawValue: category ?? 8)!.stringValue
    }
    
    var gameStatus: String {
        return GameStatus.init(rawValue: status ?? 8)?.stringValue ?? "Unknow"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ageRatings = "age_ratings"
        case aggregatedRating = "aggregated_rating"
        case aggregatedRatingCount = "aggregated_rating_count"
        case artworks
        case category
        case checksum
        case collection
        case cover
        case firstReleaseDate = "first_release_date"
        case genres
        case involvedCompanies = "involved_companies"
        case name
        case platforms
        case rating
        case ratingCount = "rating_count"
        case screenshots
        case status
        case storyline
        case summary
    }
}

enum GameCategories: Int {
    case main_game = 0
    case dlc_addon = 1
    case expansion = 2
    case bundle = 3
    case standalone_expansion = 4
    case mod = 5
    case episode = 6
    case season = 7
    
    var stringValue: String {
        switch self.rawValue {
        case 0: return "Main Game"
        case 1: return "DLC"
        case 2: return "Expansion"
        case 3: return "Bundle"
        case 4: return "Standalone Expansion"
        case 5: return "Mod"
        case 6: return "Episode"
        case 7: return "Season"
        default: return "Unknow"
        }
    }
}

enum GameStatus: Int {
    case released = 0
    case alpha = 2
    case beta = 3
    case earlyAccess = 4
    case offline = 5
    case canceled = 6
    case rumored = 7
    
    var stringValue: String {
        switch self.rawValue {
        case 0: return "Released"
        case 2: return "Alpha"
        case 3: return "Beta"
        case 4: return "Early Access"
        case 5: return "Offline"
        case 6: return "Cancelled"
        case 7: return "Rumored"
        default: return "Unknow"
        }
    }
}
