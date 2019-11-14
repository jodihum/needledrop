//
//  HomeView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/18/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                Text("Selected Playlist:")
                    .modifier(TitleTextStyle())
                    .lineLimit(1)
                    .padding(.top,30)
                Text(viewModel.selectedPlaylistName)
                    .modifier(TitleTextStyle())
                    .padding([.leading,.trailing], 20)
                    .padding(.bottom,30)
                Spacer()
                Button(action:{
                    print("tapped start test")
                }) {
                    Text("Start Test")
                }
                .buttonStyle(CallToActionButtonStyle(enabled: true))
                .padding(.bottom, 50)
                Spacer()
                
                NavigationLink(destination:Text("Settings")) {
                    Text("Settings")
                        .modifier(SecondaryButtonTextStyle())
                        .padding()
                        .padding(.bottom, 100)
                }
                
                Spacer()
                
            }
            .navigationBarTitle("Home")
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: HomeViewModel(musicDataProvider: MockMusicDataProvider()))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            
            HomeView(viewModel: HomeViewModel(musicDataProvider: MockMusicDataProvider()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
                .environment(\.colorScheme, .dark)

        }
        
    }
}
