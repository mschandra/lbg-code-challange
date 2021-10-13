//
//  TrackCell.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = ""
        durationLabel.text = ""
    }
    // MARK: Populate UI
    func setupCell(track:Track) {
        trackNameLabel.text = track.name
        durationLabel.text = track.duration
    }
}
