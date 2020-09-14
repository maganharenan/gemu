//
//  OfflineGameDetailView.swift
//  Gemu
//
//  Created by Renan Maganha on 07/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct OfflineGameDetailView: View {
    var game: Game
    @Binding var showDetail: Bool
    @State var coverImageState: CGSize = CGSize(width: .zero, height: -UIScreen.main.bounds.height)
    @State var informationContainerState: CGSize = CGSize(width: .zero, height: UIScreen.main.bounds.height)
    @State var coverInFront = true
    @State var viewDidAppear = false
    @State var hideContent = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(uiImage: UIImage(data: game.cover ?? Data()) ?? UIImage())
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
                .aspectRatio(contentMode: .fit)
                .zIndex(coverInFront ? 1 : 0)
                .offset(y: coverInFront ? coverImageState.height : -coverImageState.height)
                .rotation3DEffect(Angle(degrees: Double(coverInFront ? self.coverImageState.height / 10 : -coverImageState.height / 10)), axis: (x: -10.0, y: 0, z: 0))
                .hueRotation(Angle(degrees: Double(self.coverImageState.height)))
                .opacity(hideContent ? 0 : 1)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).speed(0.5))
                .gesture(
                    DragGesture().onChanged{ value in
                        guard value.translation.height < 0 else { return }
                        guard value.translation.height > -300 else { return }
                        self.coverImageState = value.translation
                        
                    }
                    .onEnded{ value in
                        if self.coverImageState.height < -200 {
                            self.coverInFront = false
                        }
                        self.coverImageState = .zero
                    }
            )
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(.secondary)
                    .frame(width: 80, height: 5)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView(showsIndicators: false) {
                    Text(game.name ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    Text(game.platform?.name ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                    
                    Text(game.summary ?? "")
                        .padding()
                    
                    if game.storyline != nil {
                        Text("Storyline")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                        
                        Text(game.storyline ?? "")
                            .padding()
                    }
                }
                .padding(.bottom, 116)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray2))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .zIndex(coverInFront ? 0 : 1)
            .offset(y: 100)
            .offset(y: coverInFront ? -coverImageState.height : coverImageState.height)
            .rotation3DEffect(Angle(degrees: Double(coverInFront ? -coverImageState.height / 10 : coverImageState.height / 10)), axis: (x: -10.0, y: 0, z: 0))
            .opacity(hideContent ? 0 : 1)
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).speed(0.5))
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: -10)
            .hueRotation(Angle(degrees: Double(self.coverImageState.height)))
            .gesture(
                    DragGesture().onChanged{ value in
                        guard value.translation.height < 300 else { return }
                        guard value.translation.height > 0 else { return }
                        self.coverImageState = value.translation
                        
                    }
                    .onEnded{ value in
                        if self.coverImageState.height > 200 {
                            self.coverInFront = true
                        }
                        self.coverImageState = .zero
                    }
            )
            
            Button(action: {
                self.hideContent = true
                self.coverImageState = CGSize(width: .zero, height: -UIScreen.main.bounds.height)
                self.informationContainerState = CGSize(width: .zero, height: UIScreen.main.bounds.height)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showDetail = false
                }
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.primary).colorInvert()
                    .frame(width: 44, height: 44)
                    .background(Color("DefaultButton"))
                    .clipShape(Circle())
            })
            .zIndex(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }
        .onAppear {
            self.coverImageState = .zero
            self.informationContainerState = .zero
        }
    }
}

struct OfflineGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineGameDetailView(game: Game(), showDetail: .constant(true))
    }
}
