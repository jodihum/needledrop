//
//  CreatePlaylistView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/25/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import Foundation

struct CreatePlaylistView: View {
    
    @ObservedObject var viewModel: CreatePlaylistViewModel
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: CreatePlaylistViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer()
            
            Text("Please name this new list")
                .modifier(TitleTextStyle())

            TextField("List name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing, 20.0)
                .padding()


            Button("Create list") {
                if self.viewModel.addItem(named: self.name) == true {
                   self.presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(CallToActionButtonStyle(enabled: !name.isEmpty))
            .padding()
            .disabled(self.name.isEmpty)
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage), dismissButton: .default(Text(viewModel.errorButton)))
            }

            Spacer()
        }
    }
    
}

struct CreatePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            CreatePlaylistView(viewModel: CreatePlaylistViewModel(musicDataProvider: MockMusicDataProvider()))
            .navigationBarItems(leading: Text("< Playlists").foregroundColor(.blue))
        }
    }
}
