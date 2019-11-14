//
//  PlaylistViewModel.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 11/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import Combine

class PlaylistViewModel: ObservableObject {
    @Published var playlist: Playlist? = nil
    @Published var dataSource: [PlaylistRowViewModel] = []
    @Published var showMusicPicker: Bool = false
    var songs: [Song] = []
    
    var musicDataProvider: MusicDataProvider
    var subscriber: AnyCancellable?
    
    init(playlist: Playlist?, musicDataProvider: MusicDataProvider, showMusicPicker: Bool) {
        self.playlist = playlist
        self.showMusicPicker = showMusicPicker
        self.musicDataProvider = musicDataProvider
        subscriber = musicDataProvider.songs()
            .sink(receiveValue: { receivedSongs in
                if let playlist = playlist {
                    self.songs = receivedSongs.filter({ $0.playlists?.contains(playlist) == true })
                    self.updateDataSource()
                }
            })
    }
    
    private func updateDataSource() {
        dataSource = []
        for song in songs {
            dataSource.append(PlaylistRowViewModel(song: song, musicDataProvider: self.musicDataProvider))
        }
    }
    

    func deleteItems(at offsets: IndexSet) {
        print("delete item at \(offsets)")
        if let playlist = playlist {
            musicDataProvider.deleteSongs(at: offsets, for: playlist)
        }
    }
}
