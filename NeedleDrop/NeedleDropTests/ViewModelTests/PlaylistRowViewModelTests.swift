//
//  PlaylistRowViewModelTests.swift
//  NeedleDropTests
//
//  Created by Josephine Humphreys on 11/4/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class PlaylistRowViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var playlistRowViewModel: PlaylistRowViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        let song = (musicDataProvider as? MockMusicDataProvider)?.mockSongs.first
        playlistRowViewModel = PlaylistRowViewModel(song: song!, musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        playlistRowViewModel = nil
        musicDataProvider = nil
    }
    
    func testIDReturnsSongsPersistentID() {
        XCTAssertEqual(playlistRowViewModel!.id, "A Persistent ID")
    }
    
    func testTitleReturnsSongTitle() {
        XCTAssertEqual(playlistRowViewModel!.title, "A Title")
    }
    
    func testComposerReturnsSongComposer() {
         XCTAssertEqual(playlistRowViewModel!.composer, "A Composer")
    }

    func testArtistReturnsSongArtist() {
         XCTAssertEqual(playlistRowViewModel!.artist, "A Artist")
    }
 
}
