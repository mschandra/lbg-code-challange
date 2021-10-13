//
//  AlbumData+CoreDataProperties.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//
//

import Foundation
import CoreData


extension AlbumData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumData> {
        return NSFetchRequest<AlbumData>(entityName: "AlbumData")
    }

    @NSManaged public var name: String?
    @NSManaged public var listeners: Int16
    @NSManaged public var mbid: UUID?
    @NSManaged public var url: URL?
    @NSManaged public var playcount: Int16
    @NSManaged public var artistName: String?
    @NSManaged public var tracks: NSSet?
    @NSManaged public var images: NSSet?
    @NSManaged public var wiki: WikiData?

}

// MARK: Generated accessors for tracks
extension AlbumData {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: TrackData)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: TrackData)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)

}

// MARK: Generated accessors for images
extension AlbumData {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageData)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageData)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
