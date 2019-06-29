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
        registerComicCell()
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.showsVerticalScrollIndicator = false
        settingUpCoreDataDataSource()
    }
    
    private func registerComicCell() {
        let comicNib = UINib(nibName: "ComicCell", bundle: nil)
        favoriteCollectionView.register(comicNib, forCellWithReuseIdentifier: "comicCellId")
    }
    
    private func settingUpCoreDataDataSource() {
        coreDataManager.setDelegate(viewControllerListener: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComicDesc" {
            if let theDestination = segue.destination as? ComicDetails {
                if let theSender = sender as? Comic {
                    theDestination.selectedComic = theSender
                }
            }
        }
    }
    
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComicDesc", sender: allComics[indexPath.row])
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCellId", for: indexPath) as! ComicCell
        cell.imageLoader.cancelRequest()
        cell.configureCell(row: nil, comic: allComics[indexPath.row])
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 375)
    }
}



extension FavoriteViewController: UpdateFavoriteComicDelegate {
    func update(comics: [Comic]) {
        allComics = comics
        favoriteEmptyMessag.text = allComics.isEmpty ? "You have not added any favorites yet" : ""
        favoriteCollectionView.reloadData()
    }
}
