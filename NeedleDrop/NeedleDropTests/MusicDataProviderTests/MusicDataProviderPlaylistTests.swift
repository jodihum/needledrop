//
//  MusicDataProviderPlaylistTests.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 28/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
import CoreData
@testable import NeedleDrop

class MusicDataProviderPlaylistTests: XCTestCase {

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

// add playlist
extension MusicDataProviderPlaylistTests {
    func testAddPlaylistReturnsNewPlaylist() {
        XCTContext.runActivity(named: "GIVEN a MusicDataProvider and a prepopulated data store") { _ in
            let numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        var newPlaylist: Playlist?
        XCTContext.runActivity(named: "WHEN addPlaylist is called") { _ in
            newPlaylist = try! musicDataProvider.addPlaylist(named:"Added Playlist")
        }
        
        XCTContext.runActivity(named: "THEN a new playlist is created and returned") { _ in
            XCTAssertNotNil(newPlaylist)
        }
    }
    
    func testAddPlaylistAddsNewPlaylistToStore() {
        var numberOfPlaylists = mockContainer.countPlaylists()
        XCTContext.runActivity(named: "GIVEN a store with existing playlists") { _ in
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        XCTContext.runActivity(named: "WHEN addPlaylist is called") { _ in
            let _ = try! musicDataProvider.addPlaylist(named:"Added Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the new playlist is added to the store") { _ in
            numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 4)
        }
    }
    
    func testAddPlaylistUsesCorrectOrderIndex() {
        XCTContext.runActivity(named: "GIVEN a store with existing playlists") { _ in
            let numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        var newPlaylist: Playlist?
        XCTContext.runActivity(named: "WHEN addPlaylist is called") { _ in
            newPlaylist = try! musicDataProvider.addPlaylist(named:"Added Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the new playlist has the correct orderIndex") { _ in
            XCTAssertEqual(newPlaylist!.orderIndex, 3)
        }
    }
    
    func testAddPlaylistThrowsErrorIfPlaylistAlreadyExistsWithSameName() {
        var numberOfPlaylists = mockContainer.countPlaylists()
        XCTContext.runActivity(named: "GIVEN a store with existing playlists") { _ in
            numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        var newPlaylist: Playlist?
        XCTContext.runActivity(named: "WHEN addPlaylist is called with a name that already exists") { _ in
            do {
                newPlaylist = try musicDataProvider.addPlaylist(named:"One")
            } catch DataError.playlistExistsForName {
                return
            } catch {
                XCTFail("Wrong error thrown")
                return
            }
            XCTFail("No error thrown")
        }
        
        XCTContext.runActivity(named: "THEN a new playlist is not created") { _ in
            XCTAssertNil(newPlaylist)
            numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
    }
}

// move playlist
extension MusicDataProviderPlaylistTests {
    func testMovePlaylistTowardsTop() {
        var playlists: [Playlist]?
        XCTContext.runActivity(named: "GIVEN playlists") { _ in
            playlists = mockContainer.fetchPlaylists()
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is moved towards the top of the list") { _ in
            let source = IndexSet(2..<3)
            musicDataProvider.move(playlists: playlists!, from: source, to: 0)
        }
        
        XCTContext.runActivity(named: "THEN the playlist is in the correct position and the orderIndex is correct") { _ in
            playlists =  mockContainer.fetchPlaylists()
            XCTAssertEqual(playlists!.first!.name, "Two")
            XCTAssertEqual(playlists!.first!.orderIndex, 0)
            XCTAssertEqual(playlists!.last!.name, "One")
            XCTAssertEqual(playlists!.last!.orderIndex, 2)
        }
    }
    
    func testMovePlaylistTowardsBottom() {
        var playlists: [Playlist]?
        XCTContext.runActivity(named: "GIVEN playlists") { _ in
            playlists = mockContainer.fetchPlaylists()
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is moved towards the bottom of the list") { _ in
            let source = IndexSet(0..<1)
            musicDataProvider.move(playlists: playlists!, from: source, to: 3)
        }
        
        XCTContext.runActivity(named: "THEN the playlist is in the correct position and the orderIndex is correct") { _ in
            playlists =  mockContainer.fetchPlaylists()
            XCTAssertEqual(playlists!.first!.name, "One")
            XCTAssertEqual(playlists!.first!.orderIndex, 0)
            XCTAssertEqual(playlists!.last!.name, "Zero")
            XCTAssertEqual(playlists!.last!.orderIndex, 2)
        }
    }
}

// delete playlist
extension MusicDataProviderPlaylistTests {
    func testDeletePlaylistDeletesCorrectPlaylist() {
        var playlistToDelete: Playlist?
        XCTContext.runActivity(named: "GIVEN a playlist to delete") { _ in
            playlistToDelete = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertNotNil(playlistToDelete)
        }
        
        var playlists: [Playlist]? = mockContainer.fetchPlaylists()
        XCTContext.runActivity(named: "WHEN that playlist is deleted") { _ in
            let source = IndexSet(0..<1)
            musicDataProvider.delete(from: playlists!, at: source)
        }
        
        XCTContext.runActivity(named: "THEN the correct playlist is removed") { _ in
            playlists =  mockContainer.fetchPlaylists()
            XCTAssertEqual(playlists!.count, 2)
            playlistToDelete = mockContainer.fetchPlaylist(named: "Zero")?.first
            XCTAssertNil(playlistToDelete)
        }
    }
    
    func testDeletePlaylistChangesOrderIndexOfRemainingPlaylists() {
        XCTContext.runActivity(named: "GIVEN a MusicDataProvider and a prepopulated data store") { _ in
            let numberOfPlaylists = mockContainer.countPlaylists()
            XCTAssertEqual(numberOfPlaylists, 3)
        }
        
        var playlists: [Playlist]? = mockContainer.fetchPlaylists()
        XCTContext.runActivity(named: "WHEN the first playlist is deleted") { _ in
            let source = IndexSet(0..<1)
            musicDataProvider.delete(from: playlists!, at: source)
        }
        
        XCTContext.runActivity(named: "THEN the remaining playlists have the correct order index") { _ in
            playlists =  mockContainer.fetchPlaylists()
            XCTAssertEqual(playlists!.first!.name, "One")
            XCTAssertEqual(playlists!.first!.orderIndex, 0)
            XCTAssertEqual(playlists!.last!.name, "Two")
            XCTAssertEqual(playlists!.last!.orderIndex, 1)
        }
    }
    
    func testDeletePlaylistDeletesSongsThatAreOnlyInThatPlaylist() {
        var songsToBeDeleted = [Song]()
        XCTContext.runActivity(named: "GIVEN songs that occur in only one playlist") { _ in
            let numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 7)
            songsToBeDeleted.append((mockContainer.fetchSong(titled: "F Title")?.first)!)
            songsToBeDeleted.append((mockContainer.fetchSong(titled: "G Title")?.first)!)
            XCTAssertEqual(songsToBeDeleted.count, 2)
        }
        
        let playlists: [Playlist]? = mockContainer.fetchPlaylists()
        XCTContext.runActivity(named: "WHEN that playlist is deleted") { _ in
            let source = IndexSet(2..<3)
            musicDataProvider.delete(from: playlists!, at: source)
        }
        
        XCTContext.runActivity(named: "THEN the songs that are only in that playlist are removed from storage") { _ in
            let numberOfSongs = mockContainer.countSongs()
            XCTAssertEqual(numberOfSongs, 5)
            XCTAssertEqual(mockContainer.fetchSong(titled: "F Title")!.count, 0)
            XCTAssertEqual(mockContainer.fetchSong(titled: "G Title")!.count, 0)
        }
    }
    
    func testDeletePlaylistDoesNotDeleteSongsThatAreSharedWithOtherPlaylists() {
        var playlists: [Playlist]?
        XCTContext.runActivity(named: "GIVEN playlists in the store") { _ in
            playlists = mockContainer.fetchPlaylists()
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is deleted") { _ in
            let source = IndexSet(2..<3)
            musicDataProvider.delete(from: playlists!, at: source)
        }
        
        XCTContext.runActivity(named: "THEN the songs that are shared with another playlist are not removed") { _ in
            XCTAssertEqual(mockContainer.fetchSong(titled: "A Title")!.count, 1)
            XCTAssertEqual(mockContainer.fetchSong(titled: "E Title")!.count, 1)
        }
    }
    
    func testDeletePlaylistsDeletesSelectedPlaylistWhenMatches() {
        XCTContext.runActivity(named: "GIVEN a SelectedPlaylist") { _ in
            let selectedPlaylist = mockContainer.fetchSelectedPlaylist()
            XCTAssertNotNil(selectedPlaylist)
        }
        
        let playlists: [Playlist]? = mockContainer.fetchPlaylists()
        XCTContext.runActivity(named: "WHEN that playlist is deleted") { _ in
            let source = IndexSet(2..<3)
            musicDataProvider.delete(from: playlists!, at: source)
        }
        
        XCTContext.runActivity(named: "THEN the selected Playlist is deleted from the store") { _ in
            let selectedPlaylist = mockContainer.fetchSelectedPlaylist()
            XCTAssertNil(selectedPlaylist)
        }
    }
}
