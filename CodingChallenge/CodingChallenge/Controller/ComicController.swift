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
        registerComicNib(collectionView: comicCollectionView)
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        comicCollectionView.showsVerticalScrollIndicator = false
        self.title = "Comics"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DataService.instance.segueToComicDetail {
            if let theComic = sender as? Comic {
                if let theDestination = segue.destination as? ComicDetails {
                    theDestination.selectedComic = theComic
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
        let comicForTheDay = 1
        return section == 0 ? comicForTheDay : maximumNumberOfComics
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataService.instance.comicNibId, for: indexPath) as! ComicCell
        /*
            If user scroll past the cell when the cell has not finished loaded yet, the loadings will be canceled.
         */
        cell.decodableWebRequest.cancelRequest()
        cell.imageLoader.cancelRequest()
        
        if indexPath.section == 0 {
            cell.configureCell(row: nil, comic: nil, searchRow: nil)
        } else {
            cell.configureCell(row: indexPath.row, comic: nil, searchRow: nil)
        }
        
        return cell
    }
    
}
