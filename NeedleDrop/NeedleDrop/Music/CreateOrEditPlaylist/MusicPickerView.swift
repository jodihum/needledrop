//
//  MusicPickerView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/1/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct MusicPickerView: View {
    @Binding var isShown: Bool
    @Binding var playlist: Playlist?
    var musicDataProvider: MusicDataProvider
    
    var body: some View {
        MusicPickerController(isShown: $isShown, playlist: $playlist, musicDataProvider: musicDataProvider)
    }
}

struct MusicPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let musicDataProvider = MockMusicDataProvider()
        let playlist: Binding<Playlist?> = .constant(musicDataProvider.mockPlaylists.first)
        let binding: Binding = .constant(false)
        return MusicPickerView(isShown: binding, playlist: playlist, musicDataProvider: musicDataProvider)
    }
}
