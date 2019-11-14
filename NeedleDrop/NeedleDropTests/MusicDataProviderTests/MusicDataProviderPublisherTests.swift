//
//  MusicDataProviderPublisherTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 10/31/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
import CoreData
import Combine
@testable import NeedleDrop

class MusicDataProviderPublisherTests: XCTestCase {

    var mockContainer: MockContainer!
    var musicDataProvider: MusicDataProvider!
    var subscriber: AnyCancellable?
    
    override func setUp() {
        mockContainer = MockContainer()
        musicDataProvider = DefaultMusicDataProvider(persistentContainer: mockContainer.mockPersistentContainer)
        mockContainer.populate()
    }

    override func tearDown() {
        mockContainer.cleanup()
    }

    func testPlaylistPublisherProvidesInitalValue() {
        XCTContext.runActivity(named: "GIVEN a store containing playlists") { _ in
            let numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        var playlists: [Playlist]?
        XCTContext.runActivity(named: "WHEN a subscriber is created for the playlist publisher") { _ in
            subscriber = musicDataProvider.playlists()
            .sink(receiveValue: { receivedPlaylists in
                playlists = receivedPlaylists
            })
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the initial state") { _ in
            XCTAssertNotNil(playlists)
            XCTAssertEqual(playlists?.count, 3)
        }
    }
    
    func testPlaylistPublisherUpdatesSubscribers() {
        var playlists: [Playlist]?
        XCTContext.runActivity(named: "GIVEN a subscriber") { _ in
            subscriber = musicDataProvider.playlists()
            .sink(receiveValue: { receivedPlaylists in
                playlists = receivedPlaylists
            })
            XCTAssertEqual(playlists?.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN a new playlist is added") { _ in
            let _ = try! musicDataProvider.addPlaylist(named:"Added Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the updated playlists") { _ in
            XCTAssertEqual(playlists?.count, 4)
        }
    }
    
    func testSongPublisherProvidesInitalValue() {
        XCTContext.runActivity(named: "GIVEN a store containing songs") { _ in
            let numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 7)
        }
        
        var songs: [Song]?
        XCTContext.runActivity(named: "WHEN a subscriber is created for the song publisher") { _ in
            subscriber = musicDataProvider.songs()
            .sink(receiveValue: { receivedSongs in
                songs = receivedSongs
            })
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the initial state") { _ in
            XCTAssertNotNil(songs)
            XCTAssertEqual(songs?.count, 7)
        }
    }
    
    func testSongPublisherUpdatesSubscribers() {
        var songs: [Song]?
        XCTContext.runActivity(named: "GIVEN a subscriber") { _ in
            subscriber = musicDataProvider.songs()
            .sink(receiveValue: { receivedSongs in
                songs = receivedSongs
            })
            XCTAssertEqual(songs?.count, 7)
        }
        
        XCTContext.runActivity(named: "WHEN new songs are added") { _ in
            let mediaItemH = MediaItem(persistentID:"H")
            let mediaItemI = MediaItem(persistentID:"I")
            let newSongs = [mediaItemH, mediaItemI]
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.addSongs(in: newSongs, to: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the updated songs") { _ in
            XCTAssertEqual(songs?.count, 9)
        }
    }
    
    func testSelectedPlaylistPublisherProvidesInitalValue() {
        XCTContext.runActivity(named: "GIVEN a store containing a selectedPlaylist") { _ in
            let selectedPlaylist = mockContainer.fetchSelectedPlaylist()
            XCTAssertNotNil(selectedPlaylist)
        }
        
        var initialSelectedPlaylist: SelectedPlaylist?
        XCTContext.runActivity(named: "WHEN a subscriber is created for the playlist publisher") { _ in
            subscriber = musicDataProvider.selectedPlaylist()
            .sink(receiveValue: { selectedPlaylist in
                initialSelectedPlaylist = selectedPlaylist
            })
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the initial state") { _ in
            XCTAssertNotNil(initialSelectedPlaylist)
        }
    }
    
    func testSelectedPlaylistPublisherUpdatesSubscribers() {
        var selectedPlaylist: SelectedPlaylist?
        XCTContext.runActivity(named: "GIVEN a subscriber") { _ in
            subscriber = musicDataProvider.selectedPlaylist()
            .sink(receiveValue: { receivedSelectedPlaylist in
                selectedPlaylist = receivedSelectedPlaylist
            })
            XCTAssertEqual(selectedPlaylist?.playlist?.name, "Two")
        }
        
        XCTContext.runActivity(named: "WHEN a different playlist is selected") { _ in
            let newPlaylist = mockContainer.fetchPlaylist(named: "One")?.first
            musicDataProvider.updateSelectedPlaylist(with: newPlaylist!)
        }
        
        XCTContext.runActivity(named: "THEN the subscriber receives the updated selected playlist") { _ in
            XCTAssertEqual(selectedPlaylist?.playlist?.name, "One")
        }
    }


}
