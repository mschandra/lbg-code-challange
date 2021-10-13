//
//  AlbumInfoViewModel.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
// MARK: Local Data object to share data to View
struct AlbumInfoDisplayVM {
    var name : String!
    var artistName : String?
    var url:URL?
    var tracks: [Track]?
    var summary:String?
    var publishedOn : String?
}
struct Track {
    var name : String = "NA"
    var duration : String = "0.00"
}

class AlbumInfoViewModel : NSObject {
    
    var albumInfo: AlbumInfoDisplayVM?
    
    private var service : AlbumsService?
   
    private var refreshHandler: ViewModelToViewCallBack?
   
    private var albumName:String!
    private var artist:String!
    
    init(name:String, artist:String) {
        super.init()
        self.albumName = name
        self.artist = artist
        service = AlbumsService(webClient: WebServiceClient())
    }
    // MARK: Business method call to get Album info
    func getAlbumInfo(completionHandler block: ViewModelToViewCallBack?) {
        self.refreshHandler = block
        service?.successCallBack = albumInfoSuccess()
        service?.failureCallBack = albumsInfoFail()
        service?.getAlbumInfo(albumName: albumName, artistName: artist)
    }
    // MARK: Business method callbacks
    private func albumInfoSuccess() -> SuccessModelBlock {
       return { [weak self] model in
            guard let album = model as? JsonAlbum else  { return }
            
            DataStore.saveAlbumInfo(album: album) { (status, albumData) in
                self?.setAlbumInfoToDisplay(albumData)
                self?.refreshHandler?(true,nil)
            }
        }
    }
    private func albumsInfoFail() -> FailureBlock {
        return { [weak self] (error) in
            self?.refreshHandler?(false,error)
        }
    }
    
    // MARK: Makes the viewable data objects ready for view/viewcontroller
    private func setAlbumInfoToDisplay(_ value:AlbumData?) {
        guard let albumData = value else { return }
           
        let name = albumData.name
        let artist = albumData.artistName
        var tracks = [Track]()
        let summary = albumData.wiki?.summary
        let publishedOn = albumData.wiki?.published?.displayText
        
        let url = (albumData.images?.allObjects.filter({ (img) -> Bool in
           return (img as? ImageData)?.sizeType == "extralarge" || (img as? ImageData)?.sizeType == "large" || (img as? ImageData)?.sizeType == "medium"
        }).last as? ImageData)?.url
           
        albumData.tracks?.forEach({ (track) in
            if let tractdata = track as? TrackData {
                let durationData = Int(tractdata.duration).minutesToHoursMinutes()
                let duration = "\(durationData.hours):\(durationData.minutes)"
                tracks.append(Track(name:tractdata.name ?? "NA" , duration: duration))
            }
        })
        albumInfo = AlbumInfoDisplayVM(name: name, artistName: artist,url:url, tracks: tracks, summary:summary, publishedOn:publishedOn)
    }
    
    public func setWebClient(client:NetworkClient) {
        service?.networkClient = client
    }
}

