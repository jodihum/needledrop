//
//  ListOfPlaylistsRowView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/24/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//


import SwiftUI

struct ListOfPlaylistsRowView: View {
    @ObservedObject var viewModel: ListOfPlaylistsRowViewModel

    
    init(viewModel: ListOfPlaylistsRowViewModel) {
      self.viewModel = viewModel
    }
    

    var body: some View {
        HStack {
            Text(viewModel.playlist.name ?? "")
            
            Text("\(viewModel.playlist.orderIndex)")
            
            // To avoid discloser indicators
            NavigationLink(destination: viewModel.playlistView) {
                EmptyView()
            }
        
            Spacer()
            
            Image(systemName: viewModel.imageName)
                .foregroundColor(viewModel.imageColor)
                .onTapGesture {
                    self.viewModel.selectPlaylist()
                }
        }
    }
}


struct ListOfPlaylistsRowView_Previews: PreviewProvider {
    static var previews: some View {
        let musicDataProvider = MockMusicDataProvider()
        if let playlist = musicDataProvider.mockPlaylists.first {
            return AnyView(ListOfPlaylistsRowView(viewModel: ListOfPlaylistsRowViewModel(playlist: playlist, musicDataProvider: musicDataProvider)))
        }
       return AnyView(Text("Something went wrong"))
    }
}
