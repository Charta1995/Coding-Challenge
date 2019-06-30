//
//  SharedExtentions.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 30/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

/*
    Registering ComicCell nib when called
 */
extension UIViewController {
    func registerComicNib(collectionView: UICollectionView) {
        let nib = UINib(nibName: "ComicCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: DataService.instance.comicNibId)
    }
}

/*
    Layout who are shared
 */
extension UIViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 375)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView.numberOfSections > 1 {
            if section == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 25)
            }
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 0)
    }
}

/* Sharing didSelect */
extension UIViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ComicCell else {return}
        guard let comicObjectFromSelectedCell = selectedCell.getCurrentComic() else {return}
        performSegue(withIdentifier: "toComicDesc", sender: comicObjectFromSelectedCell)
    }
}
