//
//  MusicDataProvider.swift
//  NeedleDrop
//
//  Created by Jodi Humphreys on 21/10/2019.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation
import CoreData
import Combine

enum DataError: Error {
    case playlistExistsForName
}

protocol MusicDataProvider {
    
    // publishers
    func playlists() -> AnyPublisher<[Playlist], Never>
    func selectedPlaylist() -> AnyPublisher<SelectedPlaylist?, Never>
    func songs() -> AnyPublisher<[Song], Never>
    
    // playlists
    func addPlaylist(named name: String) throws -> Playlist
    func move(playlists: [Playlist], from source: IndexSet, to destination: Int)
    func delete(from playlists:[Playlist], at offsets: IndexSet)

    // selected playlist
    func updateSelectedPlaylist(with playlist: Playlist)
    
    //songs
    func addSongs(in collection: [MediaItem], to playlist: Playlist)
    func deleteSongs(at offsets: IndexSet, for playlist: Playlist)
    
}

class DefaultMusicDataProvider: NSObject {
   
    var persistentContainer: NSPersistentContainer
    
    let playlistsSubject = CurrentValueSubject<[Playlist], Never>([])
    let selectedPlaylistSubject = CurrentValueSubject<SelectedPlaylist?, Never>(nil)
    let songsSubject = CurrentValueSubject<[Song], Never>([])
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    private func save() {
        guard managedObjectContext.hasChanges else {
            print("no changes")
            return
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("error saving")
            //TODO handle error
        }
    }
    
    
    // FetchedResultsControllers

    private lazy var playlistFetchedResultsController: NSFetchedResultsController<Playlist> = {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\Playlist.orderIndex, ascending: true)]
        
        let fetchedResultsControler = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsControler.delegate = self
        return fetchedResultsControler
    }()
    
    private lazy var selectedPlaylistFetchedResultsController: NSFetchedResultsController<SelectedPlaylist> = {
        let fetchRequest: NSFetchRequest<SelectedPlaylist> = SelectedPlaylist.fetchRequest()
        // not really using this sort descriptor but it is required to have one
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\SelectedPlaylist.playlist, ascending: true)]
        
        let fetchedResultsControler = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsControler.delegate = self
        return fetchedResultsControler
    }()
    
    private lazy var songsFetchedResultsController: NSFetchedResultsController<Song> = {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.sortDescriptors = fetchSongsSortDescriptors
        
        let fetchedResultsControler = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsControler.delegate = self
        return fetchedResultsControler
    }()
    
    var fetchSongsSortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath:\Song.artist, ascending: true),
                                                                NSSortDescriptor(keyPath:\Song.albumTitle, ascending: true),
                                                                NSSortDescriptor(keyPath:\Song.albumTrackNumber, ascending: true),
                                                                NSSortDescriptor(keyPath:\Song.title, ascending: true)]
    
    // Playlists
    private func fetchPlaylists() {
        do {
            try playlistFetchedResultsController.performFetch()
            let allplaylists = playlistFetchedResultsController.fetchedObjects ?? []
            playlistsSubject.send(allplaylists)
        } catch {
            fatalError()
        }
    }
    
    private func playlistExists(with name: String) -> Bool {
        let request = NSFetchRequest<Playlist>(entityName:"Playlist")
        request.predicate = NSPredicate(format: "name == %@", name)
        if let playlist = try? managedObjectContext.fetch(request) {
            if playlist.count > 0 {
                return true
            }
        }
        return false
    }
    
    private func reorder(playlists: [Playlist]) {
        for i in 0..<playlists.count {
            playlists[i].orderIndex = Int32(i)
        }
        save()
    }
    
    private func countPlaylists() -> Int {
        let request = NSFetchRequest<Playlist>(entityName:"Playlist")
        return (try? managedObjectContext.count(for: request)) ?? 0
    }
    
    // selected Playlist
    private func fetchSelectedPlaylist() {
          do {
              try selectedPlaylistFetchedResultsController.performFetch()
               let currentSelectedPlaylist = selectedPlaylistFetchedResultsController.fetchedObjects?.first
               selectedPlaylistSubject.send(currentSelectedPlaylist)
          } catch {
              fatalError()
          }
      }
    
    private func deleteSelectedPlaylistIfEquals(playlist: Playlist) {
        let request = NSFetchRequest<SelectedPlaylist>(entityName:"SelectedPlaylist")
        if let fetchedSelectedPlaylist = try? managedObjectContext.fetch(request) {
            for selectedPlaylist in fetchedSelectedPlaylist {
                if selectedPlaylist.playlist == playlist {
                    managedObjectContext.delete(selectedPlaylist)
                }
            }
        }
    }
    
    // Songs
    private func fetchSong(persistentID: String) -> Song? {

        let request = NSFetchRequest<Song>(entityName:"Song")
        request.predicate = NSPredicate(format: "persistentID == %@", persistentID)
        
        if let songs = try? managedObjectContext.fetch(request) {
            if songs.count > 0 {
                return songs[0]
            }
        }
        return nil
    }
    
    private func fetchSongs() {
        do {
            try songsFetchedResultsController.performFetch()
            let songs = songsFetchedResultsController.fetchedObjects ?? []
            songsSubject.send(songs)
        } catch {
            fatalError()
        }
    }
    
    private func fetchSongs(for playlist: Playlist) -> [Song] {
        let request = NSFetchRequest<Song>(entityName:"Song")
        request.predicate = NSPredicate(format: "any playlists == %@", playlist)
        request.sortDescriptors = fetchSongsSortDescriptors

        if let songs = try? managedObjectContext.fetch(request) {
           return songs
        }
        return []
    }
    
}

extension DefaultMusicDataProvider: MusicDataProvider {
    // publishers
    func playlists() -> AnyPublisher<[Playlist], Never> {
        fetchPlaylists()
        return playlistsSubject.eraseToAnyPublisher()
    }
    
    func selectedPlaylist() -> AnyPublisher<SelectedPlaylist?, Never> {
        fetchSelectedPlaylist()
        return selectedPlaylistSubject.eraseToAnyPublisher()
    }
    
    func songs() -> AnyPublisher<[Song], Never> {
        fetchSongs()
        return songsSubject.eraseToAnyPublisher()
    }
    
    // playlists
    func addPlaylist(named name: String) throws -> Playlist  {
       if playlistExists(with: name) {
           throw DataError.playlistExistsForName
       } else {
           let playlist = Playlist(context: managedObjectContext)
           playlist.name = name
           playlist.orderIndex = Int32(countPlaylists() - 1)
           save()
           return playlist
       }
    }
    
    func move(playlists: [Playlist], from source: IndexSet, to destination: Int) {
        var playlistsToMove = playlists
        var newDestination = destination
        
        for index in source {
            if newDestination > index {
                newDestination -= 1 // this fixes something that seems to be broken
            }
            print("moving row at \(index) to \(newDestination)")
            let playlist = playlistsToMove[index]
            
            playlist.orderIndex = Int32(newDestination)
            playlistsToMove.remove(at: index)
            playlistsToMove.insert(playlist, at: newDestination)
        }

        reorder(playlists: playlistsToMove)
        save()
    }
    
    func delete(from playlists:[Playlist], at offsets: IndexSet) {
        var allPlaylists = playlists
        
        for index in offsets {
            let playlist = allPlaylists[index]
            
            deleteSelectedPlaylistIfEquals(playlist: playlist)
                
            //For each song in playlist, if it only exists in this playlist, delete it from core data
            if let songs = playlist.songs {
                for song in songs.compactMap({ $0 as? Song }) {
                    if song.playlists?.count == 1 {
                        managedObjectContext.delete(song)
                    }
                }
            }
            
            managedObjectContext.delete(playlist)
            allPlaylists.remove(at: index)
        }
        reorder(playlists: allPlaylists)
        save()
    }
    
    //selectedPlaylist
    func updateSelectedPlaylist(with playlist: Playlist) {
        let request = NSFetchRequest<SelectedPlaylist>(entityName:"SelectedPlaylist")
        if let fetchedSelectedPlaylist = try? managedObjectContext.fetch(request) {
            if let selectedPlaylist = fetchedSelectedPlaylist.first {
                selectedPlaylist.playlist = playlist
            } else {
                // if selectedPlaylist doesn't exist yet, create it
                let selected = SelectedPlaylist(context: managedObjectContext)
                selected.playlist = playlist
            }
        }
        save()
    }
    
    
    //songs
    func deleteSongs(at offsets: IndexSet, for playlist: Playlist) {
           var songs: [Song] = fetchSongs(for: playlist) // to make sure order is correct
           
           for index in offsets {
               let song = songs[index]
               playlist.removeFromSongs(song)
               songs.remove(at: index)
               
               if song.playlists?.count == 0 {
                   //This is the only playlists containing this song, so delete it
                   managedObjectContext.delete(song)
               }
           }
           save()
       }
    
    func addSongs(in collection: [MediaItem], to playlist: Playlist) {
        // check if song already exists for this persistent ID
        for item in collection {
            guard let persistentID = item.persistentID else { return }
            let existingSong = fetchSong(persistentID: persistentID)
            
            if let existingSong = existingSong {
                // if so, just add to playlist
                playlist.addToSongs(existingSong)
            } else {
                // if not, create song then add to playlist
                let song = Song(context: managedObjectContext)
                song.title = item.title
                song.composer = item.composer
                song.artist = item.artist
                song.length = item.length
                song.url = item.url
                song.persistentID = item.persistentID
                song.albumTitle = item.albumTitle
                song.albumTrackNumber = item.albumTrackNumber
                playlist.addToSongs(song)
            }
        }
        save()
    }
}

enum EntityName: String {
    case playlist = "Playlist"
    case selectedPlaylist = "SelectedPlaylist"
    case song = "Song"
}

// MARK: DefaultMusicDataProvider + NSFetchedResultsControllerDelegate
extension DefaultMusicDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        guard let entity = controller.fetchRequest.entityName, let entityName = EntityName(rawValue: entity) else { return }
        switch entityName  {
        case .playlist:
            print("CHANGED playlists")
            let allplaylists = controller.fetchedObjects as? [Playlist] ?? []
            playlistsSubject.send(allplaylists)
        case .selectedPlaylist:
            print("CHANGED selected Playlist")
            let currentSelectedPlaylist = controller.fetchedObjects?.first as? SelectedPlaylist
            selectedPlaylistSubject.send(currentSelectedPlaylist)
        case .song:
            print("CHANGED songs")
            let songs = controller.fetchedObjects as? [Song] ?? []
            songsSubject.send(songs)
        }
    }
}
