//
//  ArtistData+CoreDataProperties.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//
//

import Foundation
import CoreData


extension ArtistData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistData> {
        return NSFetchRequest<ArtistData>(entityName: "ArtistData")
    }

    @NSManaged public var name: String?
    @NSManaged public var mbid: UUID?
    @NSManaged public var url: URL?

}
