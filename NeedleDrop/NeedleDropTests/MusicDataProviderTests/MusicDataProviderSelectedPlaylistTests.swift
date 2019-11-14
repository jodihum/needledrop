//
//  MusicDataProviderSelectedPlaylistTests.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 28/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
import CoreData
@testable import NeedleDrop

class MusicDataProviderSelectedPlaylistTests: XCTestCase {

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

    
    func testUpdateSelectedPlaylistCreateSelectedPlaylistIfNoneExists() {
        XCTContext.runActivity(named: "GIVEN a store with no selected playlist") { _ in
            mockContainer.deleteSelectedPlaylist()
            XCTAssertNil(mockContainer.fetchSelectedPlaylist())
        }
        
        XCTContext.runActivity(named: "WHEN updateSelectedPlaylist is called") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.updateSelectedPlaylist(with: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the selected playlist is created") { _ in
            XCTAssertNotNil(mockContainer.fetchSelectedPlaylist())
            XCTAssertEqual(mockContainer.fetchSelectedPlaylist()?.playlist,mockContainer.fetchPlaylist(named: "Zero")?.first)
        }
    }

    func testUpdateSelectedPlaylistUpdates() {
        XCTContext.runActivity(named: "GIVEN a store with a selected playlist") { _ in
            XCTAssertNotNil(mockContainer.fetchSelectedPlaylist())
            XCTAssertEqual(mockContainer.fetchSelectedPlaylist()?.playlist,mockContainer.fetchPlaylist(named: "Two")?.first)
        }
        
        XCTContext.runActivity(named: "WHEN updateSelectedPlaylist is called") { _ in
            let playlist = mockContainer.fetchPlaylist(named: "Zero")?.first
            musicDataProvider.updateSelectedPlaylist(with: playlist!)
        }
        
        XCTContext.runActivity(named: "THEN the selected playlist is updated") { _ in
            XCTAssertEqual(mockContainer.fetchSelectedPlaylist()?.playlist,mockContainer.fetchPlaylist(named: "Zero")?.first)
        }
    }

}
