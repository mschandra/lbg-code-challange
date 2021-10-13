//
//  AlbumSearchViewModel.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
import CoreData

struct AlbumDisplayVM {
    var name : String!
    var url : URL?
    var artistName:String?
}

class AlbumSearchViewModel : NSObject {
    
    var albums =  [AlbumDisplayVM] ()
    
    // MARK: Property that makes the viewable data objects ready for view/viewcontroller
    private var albumsToDisplay : [AlbumDisplayVM] {
       return fetchResultsController?.fetchedObjects?.map({ (albumData) -> AlbumDisplayVM in
            let name = albumData.name
            let artistName = albumData.artistName
        
            let url = (albumData.images?.allObjects.filter({ (img) -> Bool in
                
                return (img as? ImageData)?.sizeType == "extralarge" || (img as? ImageData)?.sizeType == "large" || (img as? ImageData)?.sizeType == "medium"
                }).last as? ImageData)?.url
            return AlbumDisplayVM(name: name, url: url, artistName: artistName)
        }) ?? []
    }
    
    override init() {
        super.init()
        fetchResultsController = DataStore.shared.getAlbumsFetchedResultsController()
        fetchResultsController?.delegate = self
        service = AlbumsService(webClient: WebServiceClient())
    }
    
    private var fetchResultsController:NSFetchedResultsController<AlbumData>?
    
    private var service:AlbumsService?
    
    private var refreshHandler: ViewModelToViewCallBack?
    // MARK: Method to load the previously loaded data on load of the screen
    func loadRecentData() {
        self.albums = self.albumsToDisplay
    }
    // MARK: Method to search for albums by 'search key"
    func searchAlbums(forKey searchKey:String, completionHandler block: ViewModelToViewCallBack?) {
        self.refreshHandler = block
        service?.successCallBack = albumsSearchSuccess()
        service?.failureCallBack = albumsSearchFail()
        service?.searchAlbums(for: searchKey)
    }
    // MARK: call back - success
    private func albumsSearchSuccess() -> SuccessModelBlock {
       return { [weak self] model in
            guard let albums = model as? [JsonAlbum] else  { return }
            
            DataStore.shared.updateAlbums(list: albums)
            DataStore.saveAlbums(albums: albums) { (status) in
                if let albumsDisplayData = self?.albumsToDisplay {
                    self?.albums = albumsDisplayData
                }
                self?.refreshHandler?(true,nil)
            }
        }
    }
    // MARK: call back - fail
    private func albumsSearchFail() -> FailureBlock {
        return { [weak self] (error) in
            self?.refreshHandler?(false,error)
        }
    }
    
    public func setWebClient(client:NetworkClient) {
        service?.networkClient = client
    }
}

// MARK: fetchResultsController delegate
extension AlbumSearchViewModel : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.refreshHandler?(true,nil)
    }
}
