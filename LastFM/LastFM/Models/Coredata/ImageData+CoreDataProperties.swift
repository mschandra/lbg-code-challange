//
//  ImageData+CoreDataProperties.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var url: URL?
    @NSManaged public var sizeType: String?
    @NSManaged public var refId: String?
}
