//
//  CompanyResponse.swift
//  Gemu
//
//  Created by Renan Maganha on 03/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

struct CompanyResponse: Codable, Equatable {
    var description: String?
    var logo: Int?
    var name: String?
}
