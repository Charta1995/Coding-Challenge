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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! ComicCell
        /*
            If user scroll past the cell when the cell has not finished loaded yet, the loadings will be canceled.
         */
        cell.decodableWebRequest.cancelRequest()
        cell.imageLoader.cancelRequest()
        
        cell.configureCell(row: indexPath.row)
        return cell
    }
    
    
}

extension ComicController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ComicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize()
    }
}
