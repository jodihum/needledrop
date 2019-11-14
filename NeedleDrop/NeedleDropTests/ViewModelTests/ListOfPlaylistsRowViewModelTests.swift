//
//  ListOfPlaylistsRowViewModelTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 11/4/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class ListOfPlaylistsRowViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var listOfPlaylistsRowViewModel: ListOfPlaylistsRowViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        let playlist = (musicDataProvider as? MockMusicDataProvider)?.mockPlaylists.first
        listOfPlaylistsRowViewModel = ListOfPlaylistsRowViewModel(playlist: playlist!, musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        listOfPlaylistsRowViewModel = nil
        musicDataProvider = nil
    }
    
}

//create views
extension ListOfPlaylistsRowViewModelTests {
    func testCreatesPlaylistView() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            XCTAssertNil(view)
            view = listOfPlaylistsRowViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN it is a PlaylistView") { _ in
            XCTAssertNotNil(view)
        }
    }

    
    func testCreatesPlaylistViewWithPresentMusicPickerFalse() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
        }
        
        var view: PlaylistView?
        XCTContext.runActivity(named: "WHEN retrieve playlistsView") { _ in
            XCTAssertNil(view)
            view = listOfPlaylistsRowViewModel?.playlistView as? PlaylistView
        }
        
        XCTContext.runActivity(named: "THEN the PlaylistView's view model has Present Music Picker False") { _ in
            let viewModel = view!.viewModel as PlaylistViewModel
            XCTAssertFalse(viewModel.showMusicPicker)
        }
    }
}

// subscription
extension ListOfPlaylistsRowViewModelTests {
    func testReceivesInitialSelectedPlaylistAndUpdatesCirclesWhenMatching() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN the initial selected playlist equals the playlist for this row") { _ in
            let playlist = (musicDataProvider as? MockMusicDataProvider)?.mockPlaylists.last
            listOfPlaylistsRowViewModel = ListOfPlaylistsRowViewModel(playlist: playlist!, musicDataProvider: musicDataProvider!)
            XCTAssertEqual(listOfPlaylistsRowViewModel?.playlist, (musicDataProvider as! MockMusicDataProvider).mockSelectedPlaylist!.playlist)
        }
        
        XCTContext.runActivity(named: "THEN the circle is checked and filled") { _ in
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageName, "checkmark.circle.fill")
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageColor, Colors.main)
        }
    }
    
    func testReceivesInitialSelectedPlaylistAndUpdatesCirclesWhenNotMatching() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN the initial selected playlist does not equal the playlist for this row") { _ in
            XCTAssertNotEqual(listOfPlaylistsRowViewModel?.playlist, (musicDataProvider as! MockMusicDataProvider).mockSelectedPlaylist!.playlist)
        }
        
        XCTContext.runActivity(named: "THEN the circle is not checked") { _ in
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageName, "circle")
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageColor, Colors.secondary)
        }
    }
    
    func testReceivesUpdatesToSelectedPlaylist() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel for a playlist not matching the initial selected playlist ") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
            XCTAssertNotEqual(listOfPlaylistsRowViewModel?.playlist, (musicDataProvider as! MockMusicDataProvider).mockSelectedPlaylist!.playlist)
        }
        
        XCTContext.runActivity(named: "WHEN the selected playlist is updated to be the row's playlist") { _ in
            let newPlaylist = (musicDataProvider as! MockMusicDataProvider).mockPlaylists.first
            musicDataProvider?.updateSelectedPlaylist(with: newPlaylist!)
        }
        
        XCTContext.runActivity(named: "THEN the circle is checked and filled") { _ in
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageName, "checkmark.circle.fill")
            XCTAssertEqual(listOfPlaylistsRowViewModel?.imageColor, Colors.main)
        }
    }
}

extension ListOfPlaylistsRowViewModelTests {
    func testSelectPlaylistUpdatesMusicDataProvider() {
        XCTContext.runActivity(named: "GIVEN a listOfPlaylistsRowViewModel") { _ in
            XCTAssertNotNil(listOfPlaylistsRowViewModel)
            XCTAssertNotEqual((musicDataProvider as! MockMusicDataProvider).mockSelectedPlaylist!.playlist, listOfPlaylistsRowViewModel?.playlist)

        }
        
        XCTContext.runActivity(named: "WHEN selectPlaylist is called") { _ in
            listOfPlaylistsRowViewModel?.selectPlaylist()
        }
        
        XCTContext.runActivity(named: "THEN the music data provider receives the new selected playlist") { _ in
            XCTAssertEqual((musicDataProvider as! MockMusicDataProvider).mockSelectedPlaylist!.playlist, listOfPlaylistsRowViewModel?.playlist)
        }
    }
}
