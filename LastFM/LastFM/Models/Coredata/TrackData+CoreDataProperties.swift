//
//  TrackData+CoreDataProperties.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//
//

import Foundation
import CoreData


extension TrackData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackData> {
        return NSFetchRequest<TrackData>(entityName: "TrackData")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: URL?
    @NSManaged public var duration: Int16
    @NSManaged public var artist: ArtistData?
    @NSManaged public var refId: String?
}
