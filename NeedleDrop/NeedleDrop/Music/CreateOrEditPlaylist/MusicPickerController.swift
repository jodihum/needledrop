//
//  MusicPickerController.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/25/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import UIKit
import MediaPlayer


struct MusicPickerController: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var playlist: Playlist?
    var musicDataProvider: MusicDataProvider
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, playlist: $playlist, musicDataProvider: musicDataProvider)
    }
    
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        print("making media picker controller")
        let mediaPickerController = MPMediaPickerController(mediaTypes: .music)
        mediaPickerController.allowsPickingMultipleItems = true
        mediaPickerController.showsCloudItems = false
        mediaPickerController.showsItemsWithProtectedAssets = false
        mediaPickerController.delegate = context.coordinator
        
        return mediaPickerController
    }

    func updateUIViewController(_ mediaController: MPMediaPickerController, context: Context) {
        print("updating media picker controller")
    }
    
    class Coordinator: NSObject, MPMediaPickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var playlist: Playlist?
        var musicDataProvider: MusicDataProvider
        
        init(isShown: Binding<Bool>, playlist: Binding<Playlist?>, musicDataProvider: MusicDataProvider) {
            print("initing coordinator with is shown = \(isShown)")
            _isShown = isShown
            _playlist = playlist
            self.musicDataProvider = musicDataProvider
        }
        
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            //myMediaPlayer.setQueue(with: mediaItemCollection)
            mediaPicker.dismiss(animated: true, completion: nil)
            isShown = false
            //myMediaPlayer.play()
            addSongs(in: mediaItemCollection)
            print("dismissed media picker")
        }

        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            mediaPicker.dismiss(animated: true, completion: nil)
            isShown = false
            print("canceled media picker")
        }
        
        private func addSongs(in mediaCollection: MPMediaItemCollection) {
            if let playlist = playlist {
                let songs = items(from: mediaCollection)
                musicDataProvider.addSongs(in: songs, to: playlist)
            }
        }
        
        private func items(from mediaCollection: MPMediaItemCollection) -> [MediaItem] {
            var items = [MediaItem]()
            for item in mediaCollection.items {
                items.append(MediaItem(item))
            }
            return items
        }

    } // end of Coordinator

}
