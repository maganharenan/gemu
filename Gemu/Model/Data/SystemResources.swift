//
//  SystemResources.swift
//  Gemu - Collection Game Tracker
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import Foundation

class SystemResources {
    
    struct TabBarItem: Hashable {
        var id: Int
        var buttonName: String
        var buttonSelectedIcon: String
        var buttonUnselectedIcon: String
        var view: Views
    }
    
    let tabBarItems: [TabBarItem] = [
        TabBarItem(id: 1, buttonName: "Collection", buttonSelectedIcon: "square.stack.3d.up.fill", buttonUnselectedIcon: "square.stack.3d.up", view: .collection),
        TabBarItem(id: 2, buttonName: "Profile", buttonSelectedIcon: "person.circle.fill", buttonUnselectedIcon: "person.circle", view: .profile),
        TabBarItem(id: 3, buttonName: "Wishlist", buttonSelectedIcon: "heart.fill", buttonUnselectedIcon: "heart", view: .wishlist)
    ]
    
    let profileSegmentLabels: [String] = ["Playing","Played","Completed"]
    
    enum Views {
        case collection
        case wishlist
        case profile
    }

}
