//
//  MediaItem.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 30/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation
import MediaPlayer

struct MediaItem {
    var albumTitle: String?
    var albumTrackNumber: Int32
    var artist: String?
    var composer: String?
    var length: Double
    var persistentID: String?
    var title: String?
    var url: URL?
    
    init(_ mediaItem:MPMediaItem) {
        self.albumTitle = mediaItem.albumTitle
        self.albumTrackNumber = Int32(mediaItem.albumTrackNumber)
        self.artist = mediaItem.artist
        self.composer = mediaItem.composer
        self.length = mediaItem.playbackDuration
        self.persistentID = String(mediaItem.persistentID)
        self.title = mediaItem.title
        self.url = mediaItem.assetURL
    }
    
    // used for testing only
    init(persistentID: String) {
        self.persistentID = persistentID
        self.length = 1
        self.albumTrackNumber = 1
    }
}
