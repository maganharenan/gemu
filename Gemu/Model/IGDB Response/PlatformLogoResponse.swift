//
//  PlatformLogoResponse.swift
//  Gemu
//
//  Created by Renan Maganha on 03/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

struct PlatformLogoResponse: Codable {
    var imageId: String?
    var url: String?
    var height: Int?
    var width: Int?
    
    enum CodingKeys: String, CodingKey {
        case imageId = "image_id"
        case url
        case height
        case width
    }
}
