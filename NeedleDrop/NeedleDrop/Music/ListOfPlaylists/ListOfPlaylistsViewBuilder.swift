//
//  ListOfPlaylistsViewBuilder.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 14/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

enum ListOfPlaylistsViewBuilder {
  static func makeListOfPlaylistsView(
    musicDataProvider: MusicDataProvider
  ) -> some View {
    let viewModel = ListOfPlaylistsViewModel(musicDataProvider: musicDataProvider)
    return ListOfPlaylistsView(viewModel: viewModel)
  }
}
