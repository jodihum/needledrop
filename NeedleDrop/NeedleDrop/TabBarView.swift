//
//  TabBarView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/18/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedIndex = 0
    @ObservedObject var viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:  UIColors.title]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:  UIColors.title]
    }
 
    var body: some View {
        TabView(selection: $selectedIndex){
            viewModel.homeView
            .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
            }
            .tag(0)
            
            viewModel.listOfplaylistsView
            .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Music")
            }
            .tag(1)
            Text("Third View")
                .font(.title)
                .tabItem {
                        Image(systemName: "clock.fill")
                        Text("History")
                }
            .tag(2)
        }
        .accentColor(Colors.main)
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TabBarViewModel(musicDataProvider: MockMusicDataProvider())
        return TabBarView(viewModel: viewModel)
    }
}
