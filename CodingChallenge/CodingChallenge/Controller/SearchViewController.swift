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
    
    private var searchResult = [ComicSearch]()
    private let textWebReqest = TextWebRequest()
    private let alerts = Alerts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchBar.delegate = self
        
        registerComicNib(collectionView: searchResultCollectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
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
            self.updateDescriptioonText(isShowingContent: !result.isEmpty)
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
        searchResult = []
        searchResultCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DataService.instance.segueToComicDetail {
            if let theDestination = segue.destination as? ComicDetails {
                if let theComicObject = sender as? Comic {
                    theDestination.selectedComic = theComicObject
                }
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataService.instance.comicNibId, for: indexPath) as! ComicCell
        cell.decodableWebRequest.cancelRequest()
        cell.imageLoader.cancelRequest()
        
        cell.configureCell(row: nil, comic: nil, searchRow: searchResult[indexPath.row].id)
        return cell
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

/* ScrollView methods */
extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
