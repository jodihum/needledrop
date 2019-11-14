//
//  ListOfPlaylistsView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/19/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI


struct ListOfPlaylistsView: View {
    @ObservedObject var viewModel: ListOfPlaylistsViewModel
    @State var showCreatePlaylistView: Bool = false
    
    init(viewModel: ListOfPlaylistsViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.dataSource, content: ListOfPlaylistsRowView.init(viewModel:))
                        .onDelete(perform: viewModel.deleteItems)
                        .onMove(perform: viewModel.move)
                }
                .sheet(isPresented: $showCreatePlaylistView, onDismiss: {
                                       print("Dismissing")
                               }) {
                                self.viewModel.createPlaylistView
                               }
                .navigationBarTitle("Playlists")
                .navigationBarItems(leading: EditButton(),
                                    trailing: Button("Create List") {
                                        self.showCreatePlaylistView = true
                                    })
                
                NavigationLink(destination: viewModel.playlistView, isActive: $viewModel.newPlaylistExists) {EmptyView()
                            }
            }
            
        }
    }

}



struct ListOfPlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfPlaylistsView(viewModel: ListOfPlaylistsViewModel(musicDataProvider: MockMusicDataProvider()))
    }
}
