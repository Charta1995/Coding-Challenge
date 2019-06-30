//
//  FavoriteViewController.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var favoriteEmptyMessag: UILabel!
    
    private let coreDataManager = CoreDataManager()
    private var allComics = [Comic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        registerComicNib(collectionView: favoriteCollectionView)
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.showsVerticalScrollIndicator = false
        settingUpCoreDataDataSource()
    }
    
    /*
        Setting this class up to be the listener for coredata changes
     */
    private func settingUpCoreDataDataSource() {
        coreDataManager.setDelegate(viewControllerListener: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DataService.instance.segueToComicDetail {
            if let theDestination = segue.destination as? ComicDetails {
                if let theSender = sender as? Comic {
                    theDestination.selectedComic = theSender
                }
            }
        }
    }
    
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataService.instance.comicNibId, for: indexPath) as! ComicCell
        cell.imageLoader.cancelRequest()
        cell.configureCell(row: nil, comic: allComics[indexPath.row], searchRow: nil)
        return cell
    }
}

/*
    Updating UI based on coredata update.
 */
extension FavoriteViewController: UpdateFavoriteComicDelegate {
    func update(comics: [Comic]) {
        allComics = comics
        favoriteEmptyMessag.text = allComics.isEmpty ? "You have not added any favorites yet" : ""
        favoriteCollectionView.reloadData()
    }
}
