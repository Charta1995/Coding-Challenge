//
//  ViewController.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 27/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicController: UIViewController {
    
    @IBOutlet weak var comicCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        comicCollectionView.showsVerticalScrollIndicator = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            if let theComic = sender as? Comic {
                if let theDestination = segue.destination as? UIViewController {
                    
                }
            }
        }
    }
}

/*
    Extentions to make the code more readable and to seperate it.
 */

extension ComicController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //The maximum number of comics are 2168, but the cell uses the indexPath.row.
        //The API doesn't have anything on position 0, therefore i have to use indexPath.row + 1 in the cell
        //Which explains why the number below is one number less.
        let maximumNumberOfComics = 2167
        return maximumNumberOfComics
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCellId", for: indexPath) as! ComicCell
        /*
            If user scroll past the cell when the cell has not finished loaded yet, the loadings will be canceled.
         */
        cell.decodableWebRequest.cancelRequest()
        cell.imageLoader.cancelRequest()
        
        cell.configureCell(row: indexPath.row)
        return cell
    }
    
    
}

extension ComicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    private func setupFlowLayout() {
        if let flowLayout = comicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        }
    }
    
}

extension ComicController: DidTapComicCell {
    func cellTapped(comic: Comic) {
        performSegue(withIdentifier: "", sender: nil)
    }
}
