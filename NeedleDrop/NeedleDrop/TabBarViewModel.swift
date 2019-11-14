//
//  TabBarViewModel.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 14/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import Combine

class TabBarViewModel: ObservableObject {
    var musicDataProvider: MusicDataProvider
    
    init(musicDataProvider: MusicDataProvider) {
        self.musicDataProvider = musicDataProvider
    }
}

extension TabBarViewModel {
    var listOfplaylistsView: some View {
        return ListOfPlaylistsViewBuilder.makeListOfPlaylistsView(musicDataProvider: self.musicDataProvider)
    }
    
    var homeView: some View {
        return HomeViewBuilder.makeHomeView(musicDataProvider: self.musicDataProvider)
    }
}
