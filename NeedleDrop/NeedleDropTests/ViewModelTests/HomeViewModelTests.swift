//
//  HomeViewModelTests.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 01/11/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class HomeViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var homeViewModel: HomeViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider() as? MusicDataProvider
        homeViewModel = HomeViewModel(musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        homeViewModel = nil
        musicDataProvider = nil
    }

     func testHomeViewReceivesInitialSelectedPlaylist() {
        XCTContext.runActivity(named: "GIVEN a homeViewModel") { _ in
            XCTAssertNotNil(homeViewModel)
        }
        
        XCTContext.runActivity(named: "THEN the selectedPlaylistName is populated ") { _ in
            XCTAssertEqual(homeViewModel?.selectedPlaylistName, "Two")
        }
    }
    
    func testHomeViewUpdatesSelectedPlaylist() {
        XCTContext.runActivity(named: "GIVEN a homeViewModel") { _ in
            XCTAssertNotNil(homeViewModel)
        }
        
        XCTContext.runActivity(named: "WHEN selectedPlaylist is changed") { _ in
            let newPlaylist = (musicDataProvider as! MockMusicDataProvider).mockPlaylists.first
            musicDataProvider?.updateSelectedPlaylist(with: newPlaylist!)
        }
        
        XCTContext.runActivity(named: "THEN the selectedPlaylistName is populated ") { _ in
            XCTAssertEqual(homeViewModel?.selectedPlaylistName, "Zero")
        }
    }


}
