//
//  WikiData+CoreDataProperties.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//
//

import Foundation
import CoreData


extension WikiData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WikiData> {
        return NSFetchRequest<WikiData>(entityName: "WikiData")
    }

    @NSManaged public var published: Date?
    @NSManaged public var summary: String?
    @NSManaged public var content: String?

}
