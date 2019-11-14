//
//  PlaylistViewModelTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 11/4/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class PlaylistViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var playlistViewModel: PlaylistViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        let playlist = (musicDataProvider as? MockMusicDataProvider)?.mockPlaylists.first
        playlistViewModel = PlaylistViewModel(playlist: playlist, musicDataProvider: musicDataProvider!, showMusicPicker: true)
    }
    
    override func tearDown() {
        playlistViewModel = nil
        musicDataProvider = nil
    }

}

// subscription
extension PlaylistViewModelTests {
    func testReceviesInitialSongs() {
        XCTContext.runActivity(named: "GIVEN a playlistViewModel") { _ in
            XCTAssertNotNil(playlistViewModel)
        }
        
        XCTContext.runActivity(named: "THEN the initial songs are received ") { _ in
            XCTAssertEqual(playlistViewModel?.songs.count, 3)
        }
    }
    
    func testReceivesUpdatesWhenNewSongsAdded() {
        XCTContext.runActivity(named: "GIVEN a playlistViewModel") { _ in
            XCTAssertNotNil(playlistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN a song is added") { _ in
            musicDataProvider?.addSongs(in: [], to: ((musicDataProvider as? MockMusicDataProvider)?.mockPlaylists.first)!)
        }
        
        XCTContext.runActivity(named: "THEN new songs are received") { _ in
            XCTAssertEqual(playlistViewModel?.songs.count, 4)
        }
    }
    
    func testUpdatesDataSourceWithNewSongs() {
        XCTContext.runActivity(named: "GIVEN a playlistViewModel with initial datasource") { _ in
            XCTAssertEqual(playlistViewModel?.dataSource.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN a song is added") { _ in
            musicDataProvider?.addSongs(in: [], to: ((musicDataProvider as? MockMusicDataProvider)?.mockPlaylists.first)!)
        }
        
        XCTContext.runActivity(named: "THEN the datasource is updated") { _ in
            XCTAssertEqual(playlistViewModel?.dataSource.count, 4)
        }
    }
}

// musicDataProvider
extension PlaylistViewModelTests {
    func testDeleteUpdatesMusicDataProvider() {
        XCTContext.runActivity(named: "GIVEN a playlistViewModel") { _ in
            XCTAssertNotNil(playlistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN delete items is called") { _ in
            playlistViewModel!.deleteItems(at: IndexSet(0..<1))
        }
        
        XCTContext.runActivity(named: "THEN the delete songs method in the Music Data Provider is called") { _ in
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).songIndexToDelete, IndexSet(0..<1))
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).playlistToDeleteSongsFrom, playlistViewModel!.playlist)
        }
    }
}

extension PlaylistViewModelTests {
    func testFiltersSongsForPlaylist() {
        XCTContext.runActivity(named: "GIVEN a playlistViewModel") { _ in
            XCTAssertNotNil(playlistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN songs are received ") { _ in
            XCTAssertEqual(playlistViewModel?.songs.count, 3)
        }
        
        XCTContext.runActivity(named: "THEN only songs for this playlist are stored") { _ in
            let playlist = playlistViewModel?.playlist
            let songsForThisPlaylist = playlistViewModel?.songs.filter({ $0.playlists?.contains(playlist!) == true })
            XCTAssertEqual(songsForThisPlaylist,playlistViewModel?.songs)
        }
    }
}

