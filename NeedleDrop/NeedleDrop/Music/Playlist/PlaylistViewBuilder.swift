//
//  PlaylistViewBuilder.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/11/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

enum PlaylistViewBuilder {
  static func makePlaylistView(
    withPlaylist playlist: Playlist?,
    musicDataProvider: MusicDataProvider,
    presentMusicPicker: Bool
  ) -> some View {
    let viewModel = PlaylistViewModel(playlist: playlist, musicDataProvider: musicDataProvider, showMusicPicker: presentMusicPicker)
    return PlaylistView(viewModel: viewModel)
  }
}
