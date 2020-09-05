//
//  TabBarItem.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct TabBarItem: View {
    @ObservedObject var viewModel: GemuViewModel
    let tabBarItem: SystemResources.TabBarItem
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: imageSystemName())
                .frame(minWidth: 25, minHeight: 25)
            Text(tabBarItem.buttonName)
                .font(.system(size: 10))
        }
        .padding([.top, .bottom], 5)
        .foregroundColor(foregroundColor())
        .frame(maxWidth: 80, maxHeight: 50)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut) {
                self.viewModel.currentView = self.tabBarItem.view
            }
        }
    }
    
    private func foregroundColor() -> Color {
        return viewModel.currentView == tabBarItem.view ? Color("TabBarButton") : Color(UIColor.systemGray)
    }
    
    private func imageSystemName() -> String {
        return viewModel.currentView == tabBarItem.view ? tabBarItem.buttonSelectedIcon : tabBarItem.buttonUnselectedIcon
    }

}
