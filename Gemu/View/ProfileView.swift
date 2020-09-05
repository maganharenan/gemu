//
//  ProfileView.swift
//  Gemu - Collection Game Tracker
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State var segmentControllSelection = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Username")
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "gear")
                        .padding()
                })
                
            }
            gameStatusInformation
                .padding(.horizontal)
            
            Picker(selection: $segmentControllSelection, label: Text("Category Picker")) {
                ForEach(0..<SystemResources().profileSegmentLabels.count) { index in
                    Text(SystemResources().profileSegmentLabels[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HorizontalGameCollection()
                    HorizontalGameCollection()
                    HorizontalGameCollection()
                }
                
                NavigationLink(destination: SearchGameView()) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 100, style: .continuous))
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 3, y: 3)
                        .shadow(color: Color.white.opacity(0.8), radius: 4, x: -3, y: -3)
                }
                .padding()
                .padding(.bottom,50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .background(Color(UIColor.systemGray5).opacity(0.6).edgesIgnoringSafeArea(.all))
        
    }
    
    var gameStatusInformation: some View {
        HStack {
            ForEach(0..<SystemResources().profileSegmentLabels.count) { index in
                GameCountLabel(category: SystemResources().profileSegmentLabels[index], gameCount: Int.random(in: 13...64))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct GameCountLabel: View {
    var category: String
    var gameCount: Int
    
    var body: some View {
        VStack {
            Text(String(gameCount))
                .font(.footnote)
                .fontWeight(.bold)

            Text(category)
                .font(.system(size: 10))
        }
    }
}

struct HorizontalGameCollection: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("PSOne games")
                .padding([.horizontal])
            Text("5/56 of played games")
                .font(.caption)
                .padding([.horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1..<9) { index in
                        GeometryReader { geometry in
                        Image("psone_\(index)")
                            .interpolation(.high)
                            .resizable()
                            .padding(.vertical,7)
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .shadow(color: Color("ProfileGameCoverShadow").opacity(0.2), radius: 5, x: 0, y: 0)
                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / 20), axis: (x: 0, y: 10.0, z: 0))
                        }
                        .frame(width: 175, height: 200)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
