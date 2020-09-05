//
//  SwitchToggle.swift
//  Gemu
//
//  Created by Renan Maganha on 03/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

struct SwitchToggle: View {
    
    @Binding var customSwitchActive: Bool
    var title: String
    var subtitle: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.primary)
                    .font(.body)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 50, height: 32)
                    .foregroundColor(customSwitchActive ? Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) : Color(UIColor.systemGray5))
                    .animation(.easeIn(duration: 0.1))
                
                Circle()
                    .frame(width: 27, height: 27)
                    .padding(.trailing, 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 0)
                    .padding(.horizontal, 2)
                    .frame(width: 50, alignment: customSwitchActive ? .trailing : .leading)
                    .animation(Animation.linear(duration: 0.1))
            }
        }
    }
}


struct SwitchToggle_Previews: PreviewProvider {
    static var previews: some View {
        SwitchToggle(customSwitchActive: .constant(true), title: "", subtitle: "")
    }
}
