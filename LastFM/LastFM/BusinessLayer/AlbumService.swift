//
//  AlbumsService.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 30/01/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation

class AlbumsService {
    
    var successCallBack: SuccessModelBlock!
    var failureCallBack: FailureBlock!
    var currentAPI: API?
    
    var networkClient : NetworkClient?
    
    init(webClient:NetworkClient) {
        self.networkClient = webClient
    }
    
    // MARK: Call to album search webservice call
    func searchAlbums(`for` key:String) {
        currentAPI = .albumSearch
        if let hasAPI = currentAPI {
            var params = hasAPI.urlParams()
            params["album"] = key
            let requestContext = RequestContext(url: Constants.BASE_URL, method: .GET, params:params, headers: nil , body: nil)
        
            networkClient?.callServer(requestContext: requestContext, completion: self.serviceCallResponse())
        }
    }
    // MARK: Call to album info webservice call
    func getAlbumInfo(albumName:String,artistName:String ) {
        currentAPI = .albumInfo
        if let hasAPI = currentAPI {
            var params = hasAPI.urlParams()
            params["album"] = albumName
            params["artist"] = artistName
            let requestContext = RequestContext(url: Constants.BASE_URL, method: .GET, params:params, headers: nil , body: nil)
           
            networkClient?.callServer(requestContext: requestContext, completion: self.serviceCallResponse())
        }
    }
    // MARK: Callback method closure
    func serviceCallResponse() -> SuccessDataBlock {
        return {
            [weak self] (result) in
            switch result {
            case .success(let data):
                if self?.currentAPI == API.albumSearch, let model = try? JSONDecoder().decode(AlbumsResponse.self, from: data) , let albums = model.results {
                    self?.successCallBack(albums)
                } else if self?.currentAPI == API.albumInfo, let album = try? JSONDecoder().decode(AlbumResponse.self, from: data).album {
                    self?.successCallBack(album)
                } else {
                    self?.failureCallBack(.invalidResponse)
                }
            case .failure(let err):
                self?.failureCallBack((err as? AppError) ?? .networkError )
            }
        }
    }
}
