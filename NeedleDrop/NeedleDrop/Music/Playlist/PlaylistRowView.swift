//
//  PlaylistRowView.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 9/26/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct PlaylistRowView: View {
    
    @ObservedObject var viewModel: PlaylistRowViewModel
    
    init(viewModel: PlaylistRowViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.title)")
                .foregroundColor(Colors.primary)
                .font(.body)
                .lineLimit(10)
            Text("\(viewModel.artist)")
                .foregroundColor(Colors.secondary)
                .font(.caption)
                .lineLimit(10)
            Text("\(viewModel.composer)")
                .foregroundColor(Colors.primary)
                .font(.caption)
                .lineLimit(10)
        }
    }
    
}

// This is for testing the preview only
struct PreviewPlaylistRowView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Extremely Long Song Title That Won't Fit on Only One Line So we can see it wrapping")
                .foregroundColor(Colors.primary)
                .font(.body)
                .lineLimit(10)
            Text("Artist Name")
                .foregroundColor(Colors.secondary)
                .font(.caption)
                .lineLimit(10)
            Text("Composer")
                .foregroundColor(Colors.primary)
                .font(.caption)
                .lineLimit(10)
        }
    }
    
}

struct PlaylistRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewPlaylistRowView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            PreviewPlaylistRowView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
                .environment(\.colorScheme, .dark)
        }
    }
}
