//
//  GameCard.swift
//  Gemu
//
//  Created by Renan Maganha on 11/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct GameCard: View {
    @Binding var currentSelectedGame: Game?
    @Binding var showDetail: Bool
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: game!.cover ?? Data()) ?? UIImage())
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            
            VStack(alignment: .leading) {
                Text(game!.name ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.top, 2)
                    .lineLimit(2)
                
                Text(game!.platform?.name ?? "")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.top, 2)
                    .lineLimit(2)
                
                Text(game!.summary ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 100)
                
                Spacer()
            }
            .padding(5)
            .frame(maxWidth: .infinity)
        }
        .background(Color("GameCard"))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color.white.opacity(0.2), radius: 2, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
        .onTapGesture {
            self.currentSelectedGame = self.game
            self.showDetail.toggle()
        }
    }
    
    var game: Game?
}


struct GameCard_Previews: PreviewProvider {
    static var previews: some View {
        GameCard(currentSelectedGame: .constant(Game()), showDetail: .constant(false), game: Game())
    }
}
