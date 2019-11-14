//
//  MusicDataProviderSongTests.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 28/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
import CoreData
@testable import NeedleDrop

class MusicDataProviderSongTests: XCTestCase {
    
    var mockContainer: MockContainer!
    var musicDataProvider: MusicDataProvider!

    override func setUp() {
        mockContainer = MockContainer()
        musicDataProvider = DefaultMusicDataProvider(persistentContainer: mockContainer.mockPersistentContainer)
        mockContainer.populate()
    }

    override func tearDown() {
        mockContainer.cleanup()
    }

}

// add songs
extension MusicDataProviderSongTests {
    func testAddSongsCreatesSongs() {
        var numberOfSongs = mockContainer.countSongs()
        XCTContext.runActivity(named: "GIVEN a store with existing songs") { _ in
            XCTAssertEqual(numberOfSongs, 7)
        }
        
        XCTContext.runActivity(named: "WHEN new songs are added") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the new song is added to the store") { _ in
            numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 9)
        }
    }
    
    func testAddSongsDoesNotCreateIfAlreadyExists() {
        
        XCTContext.runActivity(named: "GIVEN a store with existing songs") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
            let numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 9)
        }
        
        XCTContext.runActivity(named: "WHEN some existing songs are added to a different playlist") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let playlist = mockContainer.fetchPlaylist(named: "One")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the songs are not added again") { _ in
            let numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 9)
        }
    }
    
    func testAddSongsAddsToPlaylistIfNew() {

        XCTContext.runActivity(named: "GIVEN a playlist with existing songs") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(playlist?.songs!.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN new songs are added") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the playlist contains the new songs") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(playlist?.songs!.count, 5)
        }
    }
    
    func testAddSongsAddsToPlaylistIfAlreadyExists() {
        XCTContext.runActivity(named: "GIVEN a playlist with existing songs") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(playlist?.songs!.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN songs from another playlist are added to this playlist") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let otherPlaylist = mockContainer.fetchPlaylist(named: "One")?.first
            musicDataProvider.addSongs(in: newSongs, to: otherPlaylist!)
            
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the playlist contains the new songs") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(playlist?.songs!.count, 5)
        }
    }
}

// delete songs
extension MusicDataProviderSongTests {
    func testDeleteSongRemovesFromPlaylist() {
        var playlistToDeleteFrom: Playlist?
        XCTContext.runActivity(named: "GIVEN a song to delete and a playlist") { _ in
            playlistToDeleteFrom = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(playlistToDeleteFrom?.songs!.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN that song is deleted") { _ in
            let source = IndexSet(0..<1)
            musicDataProvider.deleteSongs(at: source, for: playlistToDeleteFrom!)
        }
        
        XCTContext.runActivity(named: "THEN the song is removed from the playlist") { _ in
            XCTAssertEqual(playlistToDeleteFrom?.songs!.count, 2)
        }
    }
    
    func testDeleteSongDoesNotDeleteSongIfInAnotherPlaylist() {
        var playlistToDeleteFrom: Playlist?
        XCTContext.runActivity(named: "GIVEN a song to delete and a playlist") { _ in
            playlistToDeleteFrom = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertEqual(mockContainer.countSongs(), 7)
        }
        
        XCTContext.runActivity(named: "WHEN that song is deleted from one playlist but not others") { _ in
            let source = IndexSet(1..<2)
            musicDataProvider.deleteSongs(at: source, for: playlistToDeleteFrom!)
        }
        
        XCTContext.runActivity(named: "THEN the song is not removed from store") { _ in
            XCTAssertEqual(mockContainer.countSongs(), 6)
        }
    }
    
    func testDeleteSongDeletesSongIfNotInAnotherPlaylist() {
        var songToDelete: Song?
        var playlistToDeleteFrom: Playlist?
        XCTContext.runActivity(named: "GIVEN a song to delete and a playlist") { _ in
            songToDelete = mockContainer.fetchSong(titled: "B Title")?.first
            playlistToDeleteFrom = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertNotNil(songToDelete)
            XCTAssertEqual(mockContainer.countSongs(), 7)
        }
        
        XCTContext.runActivity(named: "WHEN that song is deleted from the only playlist containing it") { _ in
            let source = IndexSet(0..<1)
            musicDataProvider.deleteSongs(at: source, for: playlistToDeleteFrom!)
        }
        
        XCTContext.runActivity(named: "THEN the song is removed from store") { _ in
            XCTAssertEqual(mockContainer.countSongs(), 7)
        }
    }
}
