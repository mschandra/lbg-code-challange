//
//  AlbumInfoViewController.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import UIKit

class AlbumInfoViewController: UIViewController {

    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    var viewModel: AlbumInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.getAlbumInfo( completionHandler: { [weak self] (success, error) in
            if success {
                self?.handleAlbumInfo()
            }else {
                self?.handleError(appError: error)
            }
        })
    }
    // MARK:  ViewModel Callbacks Handlers
    private func handleAlbumInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.tracksTableView.reloadData()
            self?.title = self?.viewModel.albumInfo?.name ?? "Details"
            self?.publishedLabel.text = self?.viewModel.albumInfo?.publishedOn ?? ""
            if let url = self?.viewModel.albumInfo?.url {
                 Helper.load(url: url) { [weak self] (resultUrl, image) in
                     DispatchQueue.main.async {
                        self?.albumImageView.image = (image != nil) ? image : UIElement.NOIMAGE
                     }
                 }
            }else{
                 self?.albumImageView.image = UIElement.NOIMAGE
            }
        }
    }
    
    private func handleError(appError: AppError?) {
        DispatchQueue.main.async { [weak self] in
            self?.showError(message: appError?.errorDescription ?? "Unknown Error")
        }
    }
}
 // MARK:  UITableViewDataSource 
extension AlbumInfoViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albumInfo?.tracks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track_cell", for: indexPath)

        // Configure the cell...
        if  let trackCell = cell as? TrackCell, let data = viewModel.albumInfo?.tracks?[indexPath.row] {
            trackCell.setupCell(track: data)
        }
        return cell
    }
}
