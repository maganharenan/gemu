//
//  CoverResponse.swift
//  Gemu
//
//  Created by Renan Maganha on 27/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

struct CoverResponse: Codable {
    let imageID: String?
    let height: Int?
    let width: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
        case height
        case width
        case url
    }
}

