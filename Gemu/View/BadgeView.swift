//
//  BadgeView.swift
//  Gemu
//
//  Created by Renan Maganha on 12/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    var viewModel: GemuViewModel
    @State var showHeroJourney = false
    
    var body: some View {
        ZStack {
            
            Image(getBadgeName())
                .renderingMode(.none)
                .interpolation(.high)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .colorMultiply(.white)
            
            Image(getBadgeName())
                .interpolation(.high)
                .resizable()
                .aspectRatio(contentMode: .fit)
            .padding(2)
        }
        .onTapGesture {
            self.showHeroJourney.toggle()
        }
        .sheet(isPresented: $showHeroJourney) {
            HeroJourneyView(viewModel: self.viewModel)
        }
    }
    
    func getBadgeName() -> String {
        let collectedGamesCount: Int = viewModel.fetchedResultsGame.fetchedObjects?.filter{ ($0.lists?.collection == true) }.count ?? 0
        var badgeName: String {
            var name = ""
            for badge in badges {
                if collectedGamesCount >= badge.minValue && collectedGamesCount < badge.maxValue {
                    name = badge.imageName
                }
            }
            return name
        }
        return badgeName
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(viewModel: GemuViewModel())
    }
}
