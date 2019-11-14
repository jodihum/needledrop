//
//  MockMusicDataProvider.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 01/11/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation
import Combine
@testable import NeedleDrop

class MockMusicDataProvider: MusicDataProvider {
    let container = MockContainer()
    var mockPlaylists = [Playlist]()
    var mockSongs = [Song]()
    var mockSelectedPlaylist: SelectedPlaylist? = nil
    
    let playlistsSubject = CurrentValueSubject<[Playlist], Never>([])
    let songsSubject = CurrentValueSubject<[Song], Never>([])
    let selectedPlaylistSubject = CurrentValueSubject<SelectedPlaylist?, Never>(nil)
    
    var nameOfAddedPlaylist = ""
    var addPlaylistShouldSucceed = true
    var indexToDelete: IndexSet?
    var moveFrom: IndexSet?
    var moveTo: Int?
    var songIndexToDelete: IndexSet?
    var playlistToDeleteSongsFrom: Playlist?
    
    
    init() {
        container.populate()
        mockPlaylists = container.fetchPlaylists()!
        mockSongs = container.fetchSongs()!
        mockSelectedPlaylist = container.fetchSelectedPlaylist()
        selectedPlaylistSubject.send(mockSelectedPlaylist)
        playlistsSubject.send(mockPlaylists)
        songsSubject.send(mockSongs)
    }
    
    func playlists() -> AnyPublisher<[Playlist], Never> {
        return playlistsSubject.eraseToAnyPublisher()
    }
    
    func selectedPlaylist() -> AnyPublisher<SelectedPlaylist?, Never> {
        return selectedPlaylistSubject.eraseToAnyPublisher()
    }
    
    func songs() -> AnyPublisher<[Song], Never> {
        return songsSubject.eraseToAnyPublisher()
    }
    
    func addPlaylist(named name: String) throws -> Playlist {
        if addPlaylistShouldSucceed {
            nameOfAddedPlaylist = name
            let tempPlaylist = mockPlaylists.first!
            tempPlaylist.name = name
            tempPlaylist.orderIndex = 3
            mockPlaylists.append(tempPlaylist)
            playlistsSubject.send(mockPlaylists)
            return tempPlaylist
        } else {
            throw DataError.playlistExistsForName
        }
    }
    
    func move(playlists: [Playlist], from source: IndexSet, to destination: Int) {
        moveFrom = source
        moveTo = destination
    }
    
    func delete(from playlists: [Playlist], at offsets: IndexSet) {
        indexToDelete = offsets
    }
    
    func updateSelectedPlaylist(with playlist: Playlist) {
        mockSelectedPlaylist?.playlist = playlist
        selectedPlaylistSubject.send(mockSelectedPlaylist)
    }
    
    func addSongs(in collection: [MediaItem], to playlist: Playlist) {
        let tempSong = mockSongs.first!
        tempSong.title = "H Title"
        tempSong.composer = "H Composer"
        tempSong.artist = "H Artist"
        tempSong.persistentID = "H Persistent ID"
        tempSong.playlists = NSSet(array:[playlist])
        
        mockSongs.append(tempSong)
        songsSubject.send(mockSongs)
    }
    
    func deleteSongs(at offsets: IndexSet, for playlist: Playlist) {
        songIndexToDelete = offsets
        playlistToDeleteSongsFrom = playlist
    }
    
    
}
