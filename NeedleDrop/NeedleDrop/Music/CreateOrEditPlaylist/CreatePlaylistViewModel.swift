//
//  CreatePlaylistViewModel.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/15/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import Combine

class CreatePlaylistViewModel: ObservableObject {
    @Published var buttonPushed: Bool = false
    var playlist: Playlist?
    var musicDataProvider: MusicDataProvider
    @Published var showErrorAlert: Bool = false
    var errorTitle = "You already have a playlist with that name"
    var errorMessage = "Please choose another name"
    var errorButton = "OK"
    
    init(musicDataProvider: MusicDataProvider) {
        self.musicDataProvider = musicDataProvider
    }
    
    func addItem(named name: String) -> Bool {
        do {
            try playlist = musicDataProvider.addPlaylist(named: name)
            buttonPushed = true
            return true
        } catch {
            showErrorAlert = true
            return false
        }
    }
   
}

extension CreatePlaylistViewModel {
    var playlistView: some View {
        PlaylistViewBuilder.makePlaylistView(withPlaylist: playlist, musicDataProvider: self.musicDataProvider, presentMusicPicker: true)
    }
}

