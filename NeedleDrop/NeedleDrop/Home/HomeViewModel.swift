//
//  HomeViewModel.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 14/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Combine

class HomeViewModel: ObservableObject {
    
    var musicDataProvider: MusicDataProvider
    @Published var selectedPlaylistName: String = ""
    var subscriber: AnyCancellable?
   
    init(musicDataProvider: MusicDataProvider) {
        self.musicDataProvider = musicDataProvider
        subscriber = musicDataProvider.selectedPlaylist()
        .print("examine")
            .map({($0?.playlist?.name ?? "None")})
            .assign(to: \HomeViewModel.selectedPlaylistName, on: self)
    }
    
}

