//
//  SearchViewController.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var desriptionText: UILabel!
    
    private var searchResult: ComicSearchResult?
    private let textWebReqest = TextWebRequest()
    private let alerts = Alerts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchBar.delegate = self
        registerComicNib()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func registerComicNib() {
        let nib = UINib(nibName: "ComicCell", bundle: nil)
        searchResultCollectionView.register(nib, forCellWithReuseIdentifier: "searchComicCellId")
    }

    private func search(searchText: String) {
        searchBar.resignFirstResponder()
        let loadingAlert = alerts.presentLoadingAlert {
            self.alerts.forceClose()
            self.whenRequestIsCanceled(searchText: nil)
            self.searchBar.becomeFirstResponder()
        }
        
        textWebReqest.makeTextWebRequest(searchText: searchText, headers: nil, body: nil, httpMethod: .get, finished: { (result) in
            self.searchResult = result
            self.updateDescriptioonText(isShowingContent: result != nil)
            self.searchResultCollectionView.reloadData()
            loadingAlert.dismiss(animated: true, completion: nil)
        }) { (needToShowLoading) in
            if needToShowLoading {
                self.present(loadingAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func updateDescriptioonText(isShowingContent: Bool) {
        self.desriptionText.text = isShowingContent ? "" : "Search for a comic, either with text, number or a mix"
    }
    
    private func whenRequestIsCanceled(searchText: String?) {
        textWebReqest.cancelRequest()
        
        if let searchText = searchText {
            if searchText == "" {
                reset()
            } else {
                searchBar.resignFirstResponder()
            }
        } else {
            reset()
        }
        
    }
    
    private func reset() {
        updateDescriptioonText(isShowingContent: false)
        searchResult = nil
        searchResultCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComicDesc" {
            if let theDestination = segue.destination as? ComicDetails {
                if let theComicObject = sender as? Comic {
                    theDestination.selectedComic = theComicObject
                }
            }
        }
    }
    
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ComicCell else {return}
        guard let comicObjectFromSelectedCell = selectedCell.getCurrentComic() else {return}
        performSegue(withIdentifier: "toComicDesc", sender: comicObjectFromSelectedCell)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchResult = searchResult {
            return searchResult.comicSearches.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchResult = searchResult else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchComicCellId", for: indexPath) as! ComicCell
        cell.decodableWebRequest.cancelRequest()
        cell.imageLoader.cancelRequest()
        
        cell.configureCell(row: nil, comic: nil, searchRow: searchResult.comicSearches[indexPath.row].id)
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 375)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        whenRequestIsCanceled(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if searchText != "" {
            textWebReqest.cancelRequest()
            search(searchText: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
