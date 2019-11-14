//
//  Styling.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/26/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

struct Colors {
    static let main: Color = .purple
    static let disabled: Color = .gray
    static let secondary: Color = .secondary
    static let primary: Color = .primary
}

struct UIColors {
    static let title: UIColor = UIColor(named:"TitleColor") ?? .black
}

struct CallToActionButtonStyle: ButtonStyle {
    var enabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .foregroundColor(.white)
            .lineLimit(1)
            .padding()
            .padding([.leading,.trailing],50)
            .background(self.enabled ? Colors.main: Colors.disabled)
            .cornerRadius(10)
    }
}

struct CallToActionButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .lineLimit(1)
            .padding()
            .padding([.leading,.trailing],50)
            .background(Colors.main)
            .cornerRadius(10)
    }
}

struct SecondaryButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(Colors.main)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Colors.main, lineWidth: 3)
            )
    }
}

struct TitleTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(Colors.main)
    }
}





