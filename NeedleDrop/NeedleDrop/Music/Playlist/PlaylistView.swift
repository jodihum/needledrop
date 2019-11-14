//
//  PlaylistView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/26/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//
// TODO is it possible to remove animation?

import SwiftUI
import MediaPlayer

struct PlaylistView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    init(viewModel: PlaylistViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.dataSource, content: PlaylistRowView.init(viewModel:))
                .onDelete(perform: viewModel.deleteItems)
        }
            .navigationBarTitle("\(viewModel.playlist?.name ?? "")")
            .navigationBarItems( trailing: Button("Add Items") {
                print("pressed add Items")
                self.viewModel.showMusicPicker = true
            })
            .sheet(isPresented: $viewModel.showMusicPicker, onDismiss: {
                    print("Dismissing playlist")
            }) {
                MusicPickerView(isShown: self.$viewModel.showMusicPicker, playlist: self.$viewModel.playlist, musicDataProvider: self.viewModel.musicDataProvider)
            }
    }
    
}


struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        let musicDataProvider = MockMusicDataProvider()
        let playlist = musicDataProvider.mockPlaylists.first
        let viewModel = PlaylistViewModel(playlist: playlist, musicDataProvider: musicDataProvider, showMusicPicker: false)
        
        return NavigationView {
            PlaylistView(viewModel: viewModel)
        }
    }
    
}
