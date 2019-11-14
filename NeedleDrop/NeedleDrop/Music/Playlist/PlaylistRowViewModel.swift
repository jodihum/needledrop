//
//  PlaylistRowViewModel.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 11/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation

class PlaylistRowViewModel: Identifiable, ObservableObject {

    var musicDataProvider: MusicDataProvider
    
    private let song: Song
    
    init(song: Song, musicDataProvider: MusicDataProvider) {
        self.song = song
        self.musicDataProvider = musicDataProvider
    }
    
    var id: String {
        return song.persistentID ?? "no ID"
    }

    var title: String {
        return song.title ?? ""
    }
    
    var composer: String {
        return song.composer ?? ""
    }
    
    var artist: String {
        return song.artist ?? ""
    }
    
}
