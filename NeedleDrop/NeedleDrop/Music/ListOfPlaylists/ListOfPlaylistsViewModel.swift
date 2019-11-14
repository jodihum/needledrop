//
//  ListOfPlaylistsViewModel.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/11/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import Combine

class ListOfPlaylistsViewModel: ObservableObject {
    @Published var dataSource: [ListOfPlaylistsRowViewModel] = []
    var playlists: [Playlist] = []
    var musicDataProvider: MusicDataProvider
    var subscriber: AnyCancellable?
    var newPlaylist: Playlist? = nil
    @Published var newPlaylistExists: Bool = false
    var receivedFirstPlaylists: Bool = false
    var showPicker: Bool = true
    
    init(musicDataProvider: MusicDataProvider) {
        self.musicDataProvider = musicDataProvider
        subscriber = musicDataProvider.playlists()
            .sink(receiveValue: { receivedPlaylists in
                // When a new playlist has been added, will want to allow user to add items to that playlist
                // So set appropropriate flags
                if receivedPlaylists.count > self.playlists.count && self.receivedFirstPlaylists == true {
                    self.newPlaylist = self.findNewPlaylist(in: receivedPlaylists)
                    print("newPlaylist = \(String(describing: self.newPlaylist?.name))")
                    self.newPlaylistExists = true
                    self.showPicker = true
                }
                self.playlists = receivedPlaylists
                self.updateDataSource()
                self.receivedFirstPlaylists = true
            })
    }
    
    private func updateDataSource() {
        dataSource = []
        for playlist in playlists {
            dataSource.append(ListOfPlaylistsRowViewModel(playlist: playlist, musicDataProvider: self.musicDataProvider))
        }
    }
    
    private func findNewPlaylist(in newPlaylists:[Playlist]) -> Playlist? {
        // new playlist should always be the last one
        return newPlaylists.last
    }
    
    func deleteItems(at offsets: IndexSet) {
        musicDataProvider.delete(from:playlists, at: offsets)
    }
        
    func move(from source: IndexSet, to destination: Int) {
        print("will move from \(source) to \(destination)")
        musicDataProvider.move(playlists: playlists, from: source, to: destination)
    }
    
}

extension ListOfPlaylistsViewModel {
    var createPlaylistView: some View {
        return CreatePlaylistViewBuilder.makeCreatePlaylistView(musicDataProvider: self.musicDataProvider)
    }
    
    var playlistView: some View {
        let view =  PlaylistViewBuilder.makePlaylistView(withPlaylist: newPlaylist, musicDataProvider: self.musicDataProvider, presentMusicPicker: showPicker)
        showPicker = false // only want to show once
        return view
    }

}
