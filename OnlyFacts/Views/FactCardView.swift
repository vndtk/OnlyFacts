//
//  FactCardView.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

import SwiftUI

struct FactCardView: View {
    let fact: Fact
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: fact.icon)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                
                Circle()
                    .frame(width: 3, height: 3)
                
                Text("Category")
                    .font(.system(.footnote, design: .monospaced))
                
                Spacer()
            }
            
            Text(fact.content)
                .font(.system(.headline, design: .monospaced))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding(.vertical, 4)
            
            HStack {
                Text("by Author")
                    .font(.system(.callout, design: .monospaced))
                
                Spacer()
                
                HStack {
                    Image(systemName: "hand.thumbsup")
                    
                    Text("51%")
                        .font(.system(.callout, design: .monospaced))
                    
                    Image(systemName: "hand.thumbsdown")
                }
            }
            .padding(.vertical, 4)
            
            Divider()
                .padding()
        }
    }
}

