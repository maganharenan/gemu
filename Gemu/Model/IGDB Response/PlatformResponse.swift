//
//  PlatformResponse.swift
//  Gemu
//
//  Created by Renan Maganha on 28/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

struct PlatformResponse: Codable, Equatable {
    let abbreviation: String?
    let alternativeName: String?
    let category: PlatformCategoryResponse.RawValue?
    let checksum: String?
    let createdAt: Int?
    let generation: Int?
    let name: String?
    let platformLogo: Int?
    let productFamily: Int?
    let slug: String?
    let summary: String?
    let updatedAt: Int?
    let url: String?
    let versions: [Int]?
    let websites: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case abbreviation
        case alternativeName = "alternative_name"
        case category
        case checksum
        case createdAt = "created_at"
        case generation
        case name
        case platformLogo = "platform_logo"
        case productFamily = "product_family"
        case slug
        case summary
        case updatedAt = "updated_at"
        case url
        case versions
        case websites
    }
}

enum PlatformCategoryResponse: Int {
    case console = 1
    case arcade = 2
    case platform = 3
    case operating_system = 4
    case portable_console = 5
    case computer = 6
    
    var stringValue: String {
        switch self.rawValue {
        case 1: return "Console"
        case 2: return "Arcade"
        case 3: return "Platform"
        case 4: return "Operating System"
        case 5: return "Portable Console"
        case 6: return "Computer"
        default: return "Unknow"
        }
    }
}
