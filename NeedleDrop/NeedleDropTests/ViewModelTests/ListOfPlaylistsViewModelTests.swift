//
//  ListOfPlaylistsViewModelTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 11/4/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class ListOfPlaylistsViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var listOfPlaylistsViewModel: ListOfPlaylistsViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        listOfPlaylistsViewModel = ListOfPlaylistsViewModel(musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        listOfPlaylistsViewModel = nil
        musicDataProvider = nil
    }

}

//view creation
extension ListOfPlaylistsViewModelTests {
    func testCreatesCreatePlaylistView() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        var view: CreatePlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve createPlaylistView") { _ in
            XCTAssertNil(view)
            view = listOfPlaylistsViewModel?.createPlaylistView as? CreatePlaylistView
        }
        
        XCTContext.runActivity(named: "THEN it is a CreatePlaylistView") { _ in
            XCTAssertNotNil(view)
        }
    }
    
    func testCreatesPlaylistView() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            view = listOfPlaylistsViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN it is a PlaylistView") { _ in
            XCTAssertNotNil(view)
        }
    }
    
    func testCreatesPlaylistViewWithShowPickerSetTrue() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView with showPicker true (default)") { _ in
            view = listOfPlaylistsViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN the PlaylistView's view model has Present Music Picker True") { _ in
            let viewModel = view!.viewModel as PlaylistViewModel
            XCTAssertTrue(viewModel.showMusicPicker)
        }
    }
    
    func testCreatesPlaylistViewWithShowPickerSetFalse() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView with showPicker false") { _ in
            listOfPlaylistsViewModel?.showPicker = false
            view = listOfPlaylistsViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN the PlaylistView's view model has Present Music Picker False") { _ in
            let viewModel = view!.viewModel as PlaylistViewModel
            XCTAssertFalse(viewModel.showMusicPicker)
        }
    }
    
    func testSetShowPickerToFalseAfterCreatingPlaylistView() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel with showPicker set to true") { _ in
            XCTAssertTrue(listOfPlaylistsViewModel!.showPicker)
        }
        
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            let _ = listOfPlaylistsViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN showPicker is set to false") { _ in
            XCTAssertFalse(listOfPlaylistsViewModel!.showPicker)
        }
    }
}

// subscription
extension ListOfPlaylistsViewModelTests {
    func testReceivesInitialPlaylists() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        XCTContext.runActivity(named: "THEN the initial playlists are received ") { _ in
            XCTAssertEqual(listOfPlaylistsViewModel?.playlists.count, 3)
        }
    }
    
    func testReceivesUpdatesToPlaylist() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is added") { _ in
            try! _ = musicDataProvider?.addPlaylist(named: "New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN new playlists are received") { _ in
            XCTAssertEqual(listOfPlaylistsViewModel?.playlists.count, 4)
        }
    }
    
    func testWhenNewPlaylistReceivedFlagsAndNewPlaylistAreSet() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertFalse(listOfPlaylistsViewModel!.newPlaylistExists)
            XCTAssertNil(listOfPlaylistsViewModel!.newPlaylist)
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is added") { _ in
            try! _ = musicDataProvider?.addPlaylist(named: "New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN flags are set to true") { _ in
            XCTAssertTrue(listOfPlaylistsViewModel!.newPlaylistExists)
            XCTAssertTrue(listOfPlaylistsViewModel!.showPicker)
            XCTAssertNotNil(listOfPlaylistsViewModel!.newPlaylist)
        }
    }
    
    func testUpdatesDatasourceOnReceivingPlaylists() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel with initial datasource") { _ in
            XCTAssertEqual(listOfPlaylistsViewModel?.dataSource.count, 3)
        }
        
        XCTContext.runActivity(named: "WHEN a playlist is added") { _ in
            try! _ = musicDataProvider?.addPlaylist(named: "New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the datasource is updated") { _ in
            XCTAssertEqual(listOfPlaylistsViewModel?.dataSource.count, 4)
        }
    }
    
}

// MusicDataProvider
extension ListOfPlaylistsViewModelTests {
    func testDeleteItemsDeletesFromMusicDataProvider() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN delete items is called") { _ in
            listOfPlaylistsViewModel!.deleteItems(at: IndexSet(0..<1))
        }
        
        XCTContext.runActivity(named: "THEN the delete method in the Music Data Provider is called") { _ in
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).indexToDelete, IndexSet(0..<1))
        }
    }
    
    func testMoveMovesItemsInMusicDataProvider() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN move is called") { _ in
            listOfPlaylistsViewModel!.move(from: IndexSet(0..<1),to: 2)
        }
        
        XCTContext.runActivity(named: "THEN the move method in the Music Data Provider is called") { _ in
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).moveTo, 2)
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).moveFrom, IndexSet(0..<1))
        }
    }
}
