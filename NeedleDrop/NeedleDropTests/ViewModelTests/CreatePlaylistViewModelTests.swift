//
//  CreatePlaylistViewModelTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 11/4/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class CreatePlaylistViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var createPlaylistViewModel: CreatePlaylistViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        createPlaylistViewModel = CreatePlaylistViewModel(musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        createPlaylistViewModel = nil
        musicDataProvider = nil
    }
}

//create views
extension CreatePlaylistViewModelTests {
    func testCreatesPlaylistView() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel containining a playlist") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
            createPlaylistViewModel!.playlist = (musicDataProvider as! MockMusicDataProvider).mockPlaylists.first
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            view = createPlaylistViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN it is a PlaylistView") { _ in
           XCTAssertNotNil(view)
        }
    }
    
    func testCreatesPlaylistViewWithPresentMusicPickerTrue() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            view = createPlaylistViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN the PlaylistView's view model has Present Music Picker True") { _ in
            let viewModel = view!.viewModel as PlaylistViewModel
            XCTAssertTrue(viewModel.showMusicPicker)
        }
    }
}

// MusicDataProvider
extension CreatePlaylistViewModelTests {
    func testAddItemAddsPlaylistInMusicDataProvider() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN addItem is called") { _ in
            _ = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN addItem in musicDataProvider is called") { _ in
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).nameOfAddedPlaylist, "My New Playlist")
        }
    }
}

extension CreatePlaylistViewModelTests {
    func testAddReturnsTrueIfAddPlaylistSucceeds() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        var added = false
        XCTContext.runActivity(named: "WHEN addItem is called and succeeds") { _ in
            added = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN addItem returns true") { _ in
            XCTAssertTrue(added)
        }
    }
    
    func testAddReturnsFalseIfAddPlaylistFails() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        var added = true
        XCTContext.runActivity(named: "WHEN addItem is called and fails") { _ in
            (musicDataProvider as! MockMusicDataProvider).addPlaylistShouldSucceed = false
            added = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the playlist is set") { _ in
            XCTAssertFalse(added)
        }
    }
    
    func testAddItemSetsPlaylist() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN addItem is called") { _ in
            _ = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN the playlist is set") { _ in
            XCTAssertEqual(createPlaylistViewModel!.playlist!.name, "My New Playlist")
        }
    }

    
    func testAddItemChangesButtonPushedToTrue() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
            XCTAssertFalse(createPlaylistViewModel!.buttonPushed)
        }
        
        XCTContext.runActivity(named: "WHEN addItem is called") { _ in
            _ = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN buttonPushed is set to true") { _ in
            XCTAssertTrue(createPlaylistViewModel!.buttonPushed)
        }
    }
    
    func testErrorThrownInAddItemChangesShowErrorAlertToTrue() {
        XCTContext.runActivity(named: "GIVEN a createPlaylistViewModel") { _ in
            XCTAssertNotNil(createPlaylistViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN addItem is called and add playlist fails") { _ in
            (musicDataProvider as! MockMusicDataProvider).addPlaylistShouldSucceed = false
            _ = createPlaylistViewModel!.addItem(named: "My New Playlist")
        }
        
        XCTContext.runActivity(named: "THEN showErrorAlert is set to true") { _ in
            XCTAssertTrue(createPlaylistViewModel!.showErrorAlert)
        }
    }
    
}
