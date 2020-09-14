//
//  HeroJourneyView.swift
//  Gemu
//
//  Created by Renan Maganha on 13/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct HeroJourneyView: View {
    @ObservedObject var viewModel: GemuViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
            ForEach(badges, id: \.self) { badge in
                HStack {
                    Image(badge.imageName)
                        .interpolation(.high)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 100)
                        .grayscale(self.isTheAchievementUnlocked(minValue: badge.minValue) ? 1 : 0.99)
                        .opacity(self.isTheAchievementUnlocked(minValue: badge.minValue) ? 1 : 0.8)
                    
                    Text(badge.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(self.isTheAchievementUnlocked(minValue: badge.minValue) ? .primary : .secondary)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            }
        }
    }
    
    func isTheAchievementUnlocked(minValue: Int) -> Bool {
        var response: Bool {
            let gamesInCollection = viewModel.fetchedResultsGame.fetchedObjects?.filter{ ($0.lists?.collection == true) }.count ?? 0
            if gamesInCollection >= minValue {
                return true
            } else {
                return false
            }
        }
        return response
    }
}

struct HeroJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        HeroJourneyView(viewModel: GemuViewModel())
    }
}
