//
//  Badges.swift
//  Gemu
//
//  Created by Renan Maganha on 13/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

struct Badge: Hashable {
    var imageName: String
    var description: String
    var minValue: Int
    var maxValue: Int
}

let badges: [Badge] = [
    Badge(imageName: "WoodSword", description: "You just started your journey and have less than 15 games in your collection.", minValue: 0, maxValue: 14),
    Badge(imageName: "WoodShield", description: "Good job! You have added 15 games to your collection. Add 30 games to reach the next badge.", minValue: 15, maxValue: 29),
    Badge(imageName: "BronzeShield", description: "You have added 30 games to your collection. Add 65 games to reach the next badge.", minValue: 30, maxValue: 64),
    Badge(imageName: "SilverShield", description: "You have become a stronger warrior. You have added 65 games to your collection. Add 125 games to reach the next badge.", minValue: 65, maxValue: 124),
    Badge(imageName: "GoldShield", description: "You have become more dangerous, as well as the way ahead. You have added 125 games to your collection. Add 250 games to reach the next badge.", minValue: 125, maxValue: 249),
    Badge(imageName: "DiamondShield", description: "The path here has been difficult, but you have traveled it. You became the strongest warrior", minValue: 250, maxValue: 99999999)
]
