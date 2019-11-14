//
//  MockContainer.swift
//  NeedleDropTests
//
//  Created by Jodi Humphreys on 30/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation
import CoreData
@testable import NeedleDrop

class MockContainer {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NeedleDropTests", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
                                        
            if let error = error {
                fatalError("Create coordinator failed \(error)")
            }
        }
        return container
    }()
    
    func cleanup() {
        // cleanup songs
        let songFetchRequest:NSFetchRequest<Song> = NSFetchRequest<Song>(entityName: "Song")
        let songs = try! mockPersistentContainer.viewContext.fetch(songFetchRequest)
        for case let song as NSManagedObject in songs {
            mockPersistentContainer.viewContext.delete(song)
        }
        
        //cleanup playlists
        let playlistFetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
        let playlists = try! mockPersistentContainer.viewContext.fetch(playlistFetchRequest)
        for case let playlist as NSManagedObject in playlists {
            mockPersistentContainer.viewContext.delete(playlist)
        }
        
        //cleanup selected playlist
        let selectedPlaylistFetchRequest = NSFetchRequest<SelectedPlaylist>(entityName: "SelectedPlaylist")
        let selectedPlaylists = try! mockPersistentContainer.viewContext.fetch(selectedPlaylistFetchRequest)
        for case let selectedPlaylist as NSManagedObject in selectedPlaylists {
            mockPersistentContainer.viewContext.delete(selectedPlaylist)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
    
    func populate() {
        let songa = createFakeSong(withPrefix: "A")!
        let songb = createFakeSong(withPrefix: "B")!
        let songc = createFakeSong(withPrefix: "C")!
        let songd = createFakeSong(withPrefix: "D")!
        let songe = createFakeSong(withPrefix: "E")!
        let songf = createFakeSong(withPrefix: "F")!
        let songg = createFakeSong(withPrefix: "G")!
        
        createFakePlaylist("Zero", orderIndex: 0, songs: [songa, songb, songc])
        createFakePlaylist("One", orderIndex: 1, songs: [songc, songd, songe])
        createFakePlaylist("Two", orderIndex: 2, songs: [songa, songe, songf, songg], select: true)

        do {
            try mockPersistentContainer.viewContext.save()
        }  catch {
            print("populate error \(error)")
        }
    }

    private func createFakeSong(withPrefix prefix: String) -> Song? {
        let song = Song(context: mockPersistentContainer.viewContext)
        song.title = "\(prefix) Title"
        song.composer = "\(prefix) Composer"
        song.artist = "\(prefix) Artist"
        song.persistentID = "\(prefix) Persistent ID"
        return song
    }
    
    private func createFakePlaylist(_ name: String, orderIndex: Int32, songs: [Song], select: Bool = false) {
        let playlist = Playlist(context: mockPersistentContainer.viewContext)
        playlist.name = name
        playlist.orderIndex = orderIndex
        let songsToAdd = NSSet(array:songs)
        playlist.addToSongs(songsToAdd)
        
        if select {
            setSelectedPlaylist(playlist)
        }
    }
    
    private func setSelectedPlaylist(_ playlist: Playlist) {
        let selectedPlaylist = SelectedPlaylist(context: mockPersistentContainer.viewContext)
        selectedPlaylist.playlist = playlist
    }
    
}



extension MockContainer {
    func countPlaylists() -> Int {
        let request = NSFetchRequest<Playlist>(entityName:"Playlist")
        return (try? mockPersistentContainer.viewContext.count(for: request)) ?? 0
    }
    
    func countSongs() -> Int {
        let request = NSFetchRequest<Song>(entityName:"Song")
        return (try? mockPersistentContainer.viewContext.count(for: request)) ?? 0
    }
    
    func fetchPlaylists() -> [Playlist]? {
        let request = NSFetchRequest<Playlist>(entityName:"Playlist")
        request.sortDescriptors = [NSSortDescriptor(keyPath:\Playlist.orderIndex, ascending: true)]

        if let playlists = try? mockPersistentContainer.viewContext.fetch(request) {
           return playlists
        }
        return []
    }
    
    func fetchSongs() -> [Song]? {
        let request = NSFetchRequest<Song>(entityName:"Song")
        request.sortDescriptors = [NSSortDescriptor(keyPath:\Song.title, ascending: true)]

        if let songs = try? mockPersistentContainer.viewContext.fetch(request) {
           return songs
        }
        return []
    }
    
    func fetchPlaylist(named name: NSString) -> [Playlist]? {
        let request = NSFetchRequest<Playlist>(entityName:"Playlist")
        request.sortDescriptors = [NSSortDescriptor(keyPath:\Playlist.orderIndex, ascending: true)]
        request.predicate = NSPredicate(format: "name == %@", name)

        if let playlists = try? mockPersistentContainer.viewContext.fetch(request) {
           return playlists
        }
        return []
    }
    
    func fetchSong(titled title: NSString) -> [Song]? {
        let request = NSFetchRequest<Song>(entityName:"Song")
        request.predicate = NSPredicate(format: "title == %@", title)

        if let songs = try? mockPersistentContainer.viewContext.fetch(request) {
           return songs
        }
        return []
    }
    
    func fetchSelectedPlaylist() -> SelectedPlaylist? {
        let request = NSFetchRequest<SelectedPlaylist>(entityName:"SelectedPlaylist")

        if let selectedPlaylist = try? mockPersistentContainer.viewContext.fetch(request) {
            return selectedPlaylist.first
        }
        return nil
    }
    
    func deleteSelectedPlaylist() {
        let request = NSFetchRequest<SelectedPlaylist>(entityName:"SelectedPlaylist")
        if let fetchedSelectedPlaylist = try? mockPersistentContainer.viewContext.fetch(request) {
            for selectedPlaylist in fetchedSelectedPlaylist {
                mockPersistentContainer.viewContext.delete(selectedPlaylist)
            }
        }
        try! mockPersistentContainer.viewContext.save()
    }
}
