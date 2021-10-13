//
//  DataStore.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    static let shared = DataStore()
    private var albums = [JsonAlbum]()
        
    func updateAlbums(list: [JsonAlbum]) {
        albums.removeAll()
        albums.append(contentsOf: list)
    }
      
    func getAllAlbums() -> [JsonAlbum] {
      return albums
    }
    
    func  reset(){
        albums.removeAll()
    }
   
    // MARK: - Core Data stack
    private  var rootContextLocal: NSManagedObjectContext?
    // Writes objects to disk
    private var rootContext: NSManagedObjectContext? {
        get {
            if rootContextLocal == nil {
                let wc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                wc.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
                wc.mergePolicy = NSOverwriteMergePolicy
                self.rootContextLocal = wc
            }
            return rootContextLocal
        }
    }
    private var mainContextLocal: NSManagedObjectContext?
         // Used to access objects
    var mainContext: NSManagedObjectContext? {
        get {
                 
            if mainContextLocal == nil, rootContext != nil {
                     
                let managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                managedContext.parent = self.rootContext
                managedContext.mergePolicy =  NSOverwriteMergePolicy
                self.mainContextLocal = managedContext
            }
                 
            return mainContextLocal
        }
    }
    
    private var writeContextLocal: NSManagedObjectContext?
       private var writeContext: NSManagedObjectContext? {
           get {
               if writeContextLocal == nil, mainContext != nil {
                   let bc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                   bc.parent = self.mainContext
                   bc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                   self.writeContextLocal = bc
               }
               return writeContextLocal
           }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LastFM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext (_ completion: ((Bool) -> Void)? = nil) {
        guard let backGroundContext = self.writeContext, let main = self.mainContext,let root = self.rootContext   else {
            completion?(false)
            return
        }
       
        backGroundContext.performAndWait {
            if backGroundContext.hasChanges {
                do {
                    try backGroundContext.save()
                } catch {
                    completion?(false)
                    log(error)
                    return
                }
            }
        }
        
        main.performAndWait {
            if main.hasChanges {
                do {
                    try main.save()
                } catch {
                    log(error)
                    completion?(false)
                    return
                }
            }
        }
        
        root.performAndWait {
            if root.hasChanges {
                do {
                    try root.save()
                } catch {
                    log(error)
                    completion?(false)
                    return
                }
            }
            completion?(true)
            return
        }
    }
    
    private var albumsFetchedResultsController: NSFetchedResultsController<AlbumData>?
    // MARK: AlbumData fetch results controller setup method
    func getAlbumsFetchedResultsController() -> NSFetchedResultsController<AlbumData>? {
        
        if albumsFetchedResultsController == nil, let hasMainContext = mainContext {
            let request = NSFetchRequest<AlbumData>(entityName: JsonAlbum.CoreDataClassName)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            let fetchedResult =
                NSFetchedResultsController<AlbumData>(fetchRequest: request,
                                                 managedObjectContext: hasMainContext,
                                                 sectionNameKeyPath: "name",
                                                 cacheName: nil)
            
            
            do {
                try fetchedResult.performFetch()
            } catch let error as NSError {
                log(error)
            }
            
            albumsFetchedResultsController = fetchedResult
        }
        
        return albumsFetchedResultsController
    }
    // MARK: Cleanup old results
    private func cleanupHistory(_ completion: ((Bool) -> Void)? = nil) {
           
        guard let context = writeContext else { return }
        
        context.perform {
            let requestToDeleteAll = NSFetchRequest<NSFetchRequestResult>(entityName: JsonAlbum.CoreDataClassName)
            if let results = try? context.fetch(requestToDeleteAll) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
            }
            self.saveContext { (status) in
                completion?(status)
            }
        }
    }
    // MARK: Album(s) save -> core-data
    static public func saveAlbums(albums:[JsonAlbum], _ completion: ((Bool) -> Void)? = nil) {
        self.shared.cleanupHistory { (status) in
            albums.forEach { (album) in
                _ = self.shared.setupAlbumData(jsonModel: album)
            }
            self.shared.saveContext { (status) in
                completion?(status)
            }
        }
    }
   
    static public func saveAlbumInfo(album:JsonAlbum, _ completion: ((Bool, AlbumData?) -> Void)? = nil) {
        let albumData = self.shared.setupAlbumData(jsonModel: album)
        self.shared.saveContext { (status) in
            completion?(status, albumData)
        }
    }
    // MARK: Standard coredata fetch methods
    private func fetchEntity(type: String, mid: UUID,  moc: NSManagedObjectContext) -> NSManagedObject? {
        if let objects = fetchEntities(type: type, predicate: NSPredicate(format: "mbid == %@", mid.uuidString), moc: moc), !objects.isEmpty {
            return objects.first
        }
           
        return nil
    }
    
    private func fetchEntity(type: String, predicate: NSPredicate,  moc: NSManagedObjectContext) -> NSManagedObject? {
        if let objects = fetchEntities(type: type, predicate: predicate, moc: moc), !objects.isEmpty {
            return objects.first
        }
           
        return nil
    }
    
    private func fetchEntities(type: String, predicate: NSPredicate? = nil, moc: NSManagedObjectContext?) -> [NSManagedObject]? {
        guard let moc = moc else {
            return nil
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
           
        if predicate != nil {
            request.predicate = predicate
        }
        let objects = try? moc.fetch(request)
        
        return objects
    }
    // MARK: Populate JSON object(Album) to coredata fields
    private func setupAlbumData(jsonModel:JsonAlbum) -> AlbumData? {
        let entityName = JsonAlbum.CoreDataClassName
        guard let moc = self.writeContext else {
            return nil
        }
        
        var object: NSManagedObject?
        
        if let mid = jsonModel.mbid, mid.uuidString != "" {
            object = self.fetchEntity(type: entityName, mid: mid, moc: moc)
        }
        if let name = jsonModel.name, name != "" {
            object = self.fetchEntity(type: entityName, predicate: NSPredicate(format: "name == %@", name), moc: moc)
        }
        
        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc)
        }
        if let album = object as? AlbumData {
            album.name = jsonModel.name
            album.artistName = jsonModel.artistName
            album.url = jsonModel.url
            album.mbid = jsonModel.mbid
            if let refId = jsonModel.mbid?.uuidString ?? jsonModel.name {
                jsonModel.tracks?.forEach({ (jsonTrack) in
                    if let trackData = setupTrackData(for:refId, jsonModel: jsonTrack) {
                        album.addToTracks(trackData)
                    }
                })
                jsonModel.images?.forEach({ (jsonImage) in
                    if let imageData = setupImageData(for:refId, jsonModel: jsonImage) {
                        album.addToImages(imageData)
                    }
                })
            }
        }
        return object as? AlbumData
    }
    // MARK: Populate JSON object(Track) to coredata fields
    private func setupTrackData(for refId:String,jsonModel:JsonTrack) -> TrackData? {
        let entityName = JsonTrack.CoreDataClassName
        guard let moc = self.writeContext else {
            return nil
        }
        
        var object: NSManagedObject?
        
        if  let name = jsonModel.name {
            object = self.fetchEntity(type: entityName, predicate: NSPredicate(format: "refId == %@ && name == %@", refId, name), moc: moc)
        }
        
        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc)
        }
        if let track = object as? TrackData {
            track.name = jsonModel.name
            track.duration = Int16(jsonModel.duration)
            track.url = jsonModel.url
            if let hasArtist = jsonModel.artist, let artistData = setupArtistData(jsonModel: hasArtist) {
                track.artist = artistData
            }
        }
        return object as? TrackData
    }
    // MARK: Populate JSON object(Artist) to coredata fields
    private func setupArtistData(jsonModel:JsonArtist) -> ArtistData? {
        let entityName = JsonArtist.CoreDataClassName
        guard let moc = self.writeContext else {
            return nil
        }
        
        var object: NSManagedObject?
            
       if let mid = jsonModel.mbid, mid.uuidString != "" {
            object = self.fetchEntity(type: entityName, mid: mid, moc: moc)
        }
        if let name = jsonModel.name, name != "" {
            object = self.fetchEntity(type: entityName, predicate: NSPredicate(format: "name == %@", name), moc: moc)
        }
        
        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc)
        }
        if let artist = object as? ArtistData {
            artist.name = jsonModel.name
            artist.mbid = jsonModel.mbid
            artist.url = jsonModel.url
        }
        return object as? ArtistData
    }
    // MARK: Populate JSON object(Image) to coredata fields
    private func setupImageData(for refId:String,  jsonModel:JsonImage) -> ImageData? {
        let entityName = JsonImage.CoreDataClassName
        guard let moc = self.writeContext else {
            return nil
        }
        
        var object: NSManagedObject?
    
        if let size = jsonModel.size {
            object = self.fetchEntity(type: entityName, predicate: NSPredicate(format: "(refId == %@) && (sizeType == %@)", refId, size), moc: moc)
        }
        
        if object == nil {
            object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc)
        }
        
        if let image = object as? ImageData {
            image.sizeType = jsonModel.size
            image.url = jsonModel.url
        }
        
        return object as? ImageData
    }
    // MARK: Error logger
    private func log(_ error:Error) {
        print("Core data error: \(error)")
    }
}
