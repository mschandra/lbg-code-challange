//
//  AlbumsSearchViewController.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsSearchViewController: UIViewController {
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel: AlbumSearchViewModel?
    private let spacing: CGFloat = 10.0
    let CellId = "AlbumGridCell"
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel =  AlbumSearchViewModel()
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        albumsCollectionView.collectionViewLayout = GridLayout()
        
        albumsCollectionView.register(UINib(nibName: CellId, bundle: nil),
                                                             forCellWithReuseIdentifier: CellId)
        viewModel?.loadRecentData()
        
        searchBar
            .rx
            .value
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in
                guard let text = self.searchBar.text else {
                    return
                }
                self.viewModel?.searchAlbums(forKey: text, completionHandler: { [weak self] (success, error) in
                    if success {
                        self?.handleAlbums()
                    }else {
                        self?.handleError(appError: error)
                    }
                })
            })
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumInfoViewController" {
            if let input = sender as? [String:String], let vc = segue.destination as? AlbumInfoViewController {
                vc.viewModel = AlbumInfoViewModel(name: input["albumName"] ?? "", artist: input["artistName"] ?? "")
            }
        }
    }
    // MARK:  Keyboard hidding handler
    @objc func hideKeyBoard(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    // MARK:  ViewModel Callbacks Handlers
    private  func handleAlbums() {
        DispatchQueue.main.async { [weak self] in
            self?.searchBar.resignFirstResponder()
            self?.albumsCollectionView.reloadData()
        }
    }
    private  func handleError(appError: AppError?) {
         DispatchQueue.main.async { [weak self] in
            self?.searchBar.resignFirstResponder()
            self?.showError(message: appError?.errorDescription ?? "Unknown Error")
        }
    }
}
// MARK: UICollectionViewDataSource methods
extension AlbumsSearchViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.albums.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath)

        // Configure the cell...
        if  let albumCell = cell as? AlbumGridCell , let vm = viewModel {
            let data = vm.albums[indexPath.row]
            albumCell.setupCell(album: data)
        }
        return cell
    }

}
// MARK: UICollectionViewDelegate and UICollectionViewDelegateFlowLayout methods
extension AlbumsSearchViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let width =  Int(floor(collectionView.frame.width - (spacing * (itemsPerRow + 1))) / itemsPerRow)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let vm = viewModel {
            let data = vm.albums[indexPath.row]
            performSegue(withIdentifier: "AlbumInfoViewController", sender: ["albumName":data.name, "artistName":data.artistName])
        }
    }
}
// MARK: UISearchBarDelegate  methods
extension AlbumsSearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        viewModel?.searchAlbums(forKey: text, completionHandler: { [weak self] (success, error) in
            if success {
                self?.handleAlbums()
            }else {
                self?.handleError(appError: error)
            }
        })
    }
}
// MARK: Custom UICollectionViewFlowLayout
class GridLayout : UICollectionViewFlowLayout { }
