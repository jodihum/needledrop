//
//  TabBarViewModelTests.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 01/11/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import XCTest
@testable import NeedleDrop

class TabBarViewModelTests: XCTestCase {

    var musicDataProvider: MusicDataProvider?
    var tabBarViewModel: TabBarViewModel?
    
    override func setUp() {
        musicDataProvider = MockMusicDataProvider()
        tabBarViewModel = TabBarViewModel(musicDataProvider: musicDataProvider!)
    }

    override func tearDown() {
        tabBarViewModel = nil
        musicDataProvider = nil
    }

    func testTabBarViewModelCreatesListOfPlaylistView() {
        XCTContext.runActivity(named: "GIVEN a tabBarViewModel") { _ in
            XCTAssertNotNil(tabBarViewModel)
        }
        
        var view: ListOfPlaylistsView?
        XCTContext.runActivity(named: "WHEN retrieve listOfplaylistsView") { _ in
            XCTAssertNil(view)
            view = tabBarViewModel?.listOfplaylistsView as? ListOfPlaylistsView
        }
        
        XCTContext.runActivity(named: "THEN it is a ListOfPlaylistsView") { _ in
            XCTAssertNotNil(view)
        }
    }
    
    func testTabBarViewModelCreatesHomeView() {
        XCTContext.runActivity(named: "GIVEN a tabBarViewModel") { _ in
            XCTAssertNotNil(tabBarViewModel)
        }

        var view: HomeView?
        XCTContext.runActivity(named: "WHEN retrieve homeView") { _ in
            XCTAssertNil(view)
            view = tabBarViewModel?.homeView as? HomeView
        }

        XCTContext.runActivity(named: "THEN it is a HomeView") { _ in
            XCTAssertNotNil(view)
        }
    }

}
