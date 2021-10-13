//
//  Helpers.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
import UIKit

struct UIElement {
    static let NOIMAGE = UIImage(named: "no-image-available")
}

class Helper {
    // MARK: Call load image in background thread
    static func load(url: URL, completion: @escaping ((_ url:URL, _ image:UIImage?) -> Void)) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    completion(url,image)
                }
            } else {
                completion(url,nil)
            }
        }
    }
}
   
