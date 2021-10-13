//
//  Album.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
// MARK: Album data <== JSON
struct JsonAlbum : Decodable {
   
    static let CoreDataClassName = "AlbumData"
   
    var name: String?
    var artistName: String?
    var url:  URL?
    var images : [JsonImage]?
    var mbid: UUID?
    
    var tracks : [JsonTrack]?
    
    var wiki: JsonWiki?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case artistname = "artist"
        case url
        case images = "image"
        case mbid
        case tracks
        case wiki
    }
    
    enum TrackKeys: String, CodingKey {
        case track
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let hasValue = try? container.decode(UUID.self, forKey: .mbid) {
            mbid = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .name){
            name = hasValue
        }
        if let hasValue = try? container.decode([JsonImage].self, forKey: .images){
            images = hasValue
        }
        if let hasValue = try? container.decode(JsonWiki.self, forKey: .wiki){
            wiki = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .artistname) {
            artistName = hasValue
        }
        if let hasValue = try? container.decode(URL.self, forKey: .url) {
            url = hasValue
        }
        
        if let tracksContainer = try? container.nestedContainer(keyedBy: TrackKeys.self, forKey: .tracks),
            let hasValue = try? tracksContainer.decode([JsonTrack].self, forKey: .track) {
            tracks = hasValue
        }
    }
}
// MARK: Album's Image data <== JSON
struct JsonImage : Decodable {
    static let CoreDataClassName = "ImageData"
    
    var url: URL?
    var size: String?
       
    private enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let hasValue = try? container.decode(URL.self, forKey: .url) {
            url = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .size){
            size = hasValue
        }
    }
}
// MARK: Album's Wiki data <== JSON
struct JsonWiki : Decodable {
    static let CoreDataClassName = "WikiData"
    
    var published: Date?
    var summary: String?
    var content: String?
       
    private enum CodingKeys: String, CodingKey {
        case published
        case summary
        case content
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let hasValue = try? container.decode(String.self, forKey: .summary) {
            summary = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .content){
            content = hasValue
        }
        if let publishedTimeString = try? container.decode(String.self, forKey: .content) ,
            let date = DateFormatter.backendAPIFormat.date(from: publishedTimeString){
            published = date
        }
    }
}
// MARK: Track's Artist data <== JSON
struct JsonArtist : Decodable {
    static let CoreDataClassName = "ArtistData"
    var url: URL?
    var name: String?
    var mbid: UUID?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case name
        case mbid
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let hasValue = try? container.decode(URL.self, forKey: .url) {
            url = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .name){
            name  = hasValue
        }
        if let hasValue = try? container.decode(UUID.self, forKey: .mbid){
            mbid  = hasValue
        }
    }
}
// MARK: Album's Track data <== JSON
struct JsonTrack : Decodable {
    static let CoreDataClassName = "TrackData"
    var url: URL?
    var name: String?
    var artist : JsonArtist?
    var duration : Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case url
        case name
        case duration
        case artist
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let hasValue = try? container.decode(URL.self, forKey: .url) {
            url = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .name){
            name  = hasValue
        }
        if let hasValue = try? container.decode(String.self, forKey: .duration), let durationValue = Int(hasValue) {
            duration  = durationValue
        }
        if let hasValue = try? container.decode(JsonArtist.self, forKey: .artist){
            artist  = hasValue
        }
    }
}
// MARK: All Albums data <== JSON
struct AlbumsResponse :  Decodable {
    var results : [JsonAlbum]!

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           
        let albumMatchesContainer = try container.nestedContainer(keyedBy: AlbumMatchesKeys.self, forKey: .results)
        let albumsContainer = try albumMatchesContainer.nestedContainer(keyedBy: AlbumsKeys.self, forKey: .albummatches)
        results = try? albumsContainer.decode([JsonAlbum].self, forKey: .album)
    }
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    enum AlbumMatchesKeys: String, CodingKey {
        case albummatches
    }
    
    enum AlbumsKeys: String, CodingKey {
        case album
    }
}

// MARK: Single Album data <== JSON
struct AlbumResponse :  Decodable {
     var album : JsonAlbum?
}

