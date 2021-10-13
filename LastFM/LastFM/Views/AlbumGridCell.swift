//
//  AlbumGridCell.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import UIKit

class AlbumGridCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    private var urlString: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        albumImageView.image =  UIElement.NOIMAGE
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        albumImageView.image =  UIElement.NOIMAGE
    }
    // MARK: Populate UI
    func setupCell(album:AlbumDisplayVM) {
        nameLabel.text = album.name ?? ""
        urlString = album.url?.absoluteString
        if let url = album.url {
            Helper.load(url: url) { [weak self] (resultUrl, image) in
                DispatchQueue.main.async {
                    if (image == nil) {
                        self?.albumImageView.image = UIElement.NOIMAGE
                    }else if self?.urlString == resultUrl.absoluteString {
                        self?.albumImageView.image = image
                    }else{
                        self?.albumImageView.image = nil
                    }
                }
            }
        }
    }
}
