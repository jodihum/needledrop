//
//  ListOfPlaylistsRowViewModel.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/11/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ListOfPlaylistsRowViewModel: ObservableObject, Identifiable {
    var playlist: Playlist
    var musicDataProvider: MusicDataProvider
    var subscriber: AnyCancellable?
    @Published var imageName: String = "circle"
    @Published var imageColor: Color = Colors.secondary
    
    init(playlist: Playlist, musicDataProvider: MusicDataProvider) {
        self.playlist = playlist
        self.musicDataProvider = musicDataProvider
        subscriber = musicDataProvider.selectedPlaylist()
            .sink(receiveValue: { selectedPlaylist in
                self.updateCircles(selectedPlaylist: selectedPlaylist?.playlist)
            })
    }
    
    var id: String {
        return playlist.name ?? ""
    }
    
    private func updateCircles(selectedPlaylist: Playlist?) {
        if selectedPlaylist == playlist {
            self.imageName  = "checkmark.circle.fill"
            self.imageColor = Colors.main
        } else {
            self.imageName = "circle"
            self.imageColor = Colors.secondary
        }
    }
    
    func selectPlaylist() {
        musicDataProvider.updateSelectedPlaylist(with: self.playlist)
    }

}

extension ListOfPlaylistsRowViewModel {
    var playlistView: some View {
    return PlaylistViewBuilder.makePlaylistView(withPlaylist: self.playlist, musicDataProvider: self.musicDataProvider, presentMusicPicker: false)
  }
}
