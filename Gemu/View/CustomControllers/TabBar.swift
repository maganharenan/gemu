//
//  TabBar.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var viewModel: GemuViewModel
    var tabItensResource: [SystemResources.TabBarItem]
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            ForEach(SystemResources().tabBarItems, id: \.self) { item in
                TabBarItem(viewModel: self.viewModel, tabBarItem: item)
            }
        }
        .modifier(NavigationControllerBackgroundModifier())
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(viewModel: GemuViewModel(), tabItensResource: SystemResources().tabBarItems)
    }
}



struct NavigationControllerBackgroundModifier: ViewModifier {
    var lineYPosition: CGFloat = 0
    
    var backgroundSeparatorLine: some View {
        GeometryReader { parentGeometry in
            Rectangle()
                .modifier(NavigationControllerSeparatorLineModifier(width: parentGeometry.size.width, lineYPosition: self.lineYPosition))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(backgroundSeparatorLine)
            .background(Color(UIColor.systemGray6).opacity(0.95).edgesIgnoringSafeArea(.bottom))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    struct NavigationControllerSeparatorLineModifier: ViewModifier {
        var width: CGFloat
        var lineYPosition: CGFloat
        
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color(UIColor.systemGray2))
                .frame(width: width, height: 0.5)
                .position(x: width / 2, y: lineYPosition)
        }
    }
    
}

