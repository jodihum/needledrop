//
//  HomeViewBuilder.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 21/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI

enum HomeViewBuilder {
  static func makeHomeView(
    musicDataProvider: MusicDataProvider
  ) -> some View {
    let viewModel = HomeViewModel(musicDataProvider: musicDataProvider)
    return HomeView(viewModel: viewModel)
  }
}
