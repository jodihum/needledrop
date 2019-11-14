//
//  CreatePlaylistViewBuilder.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/15/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

enum CreatePlaylistViewBuilder {
  static func makeCreatePlaylistView(
    musicDataProvider: MusicDataProvider
  ) -> some View {
    let viewModel = CreatePlaylistViewModel(musicDataProvider: musicDataProvider)
    return CreatePlaylistView(viewModel: viewModel)
  }
}
