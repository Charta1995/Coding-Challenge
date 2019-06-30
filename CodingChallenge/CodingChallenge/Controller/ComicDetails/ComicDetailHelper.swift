//
//  ComicDetailHelper.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 30/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit
class ComicDetailHelper {
    
    /*
        This class is setting up ComicDetails
     */
    
    private var selectedComic: Comic!
    var cellContent = [ComicDetailsSection]()
    private let imageLoader = ImageLoader()
    var completeUrlForSpesificComic: String!
    var completeUrlForExplanation: String!
    
    init(selectedComic: Comic, contentTable: UITableView, imageZoomScrollView: UIScrollView, descriptionLbl: UILabel, comicImage: UIImageView, delegateListener: NSObject) {
        self.selectedComic = selectedComic
        getTableViewHeaderView(contentTableView: contentTable)
        setCompleteUrls()
        createCellContent(descriptionLbl: descriptionLbl)
        setupTableView(detailInfoTable: contentTable, delegateListener: delegateListener)
        setUpScrollView(imageZoomScrollView: imageZoomScrollView, delegateListener: delegateListener)
        getComicImage(comicImage: comicImage)
        startListeningForFavoriteChange(listener: delegateListener as! ComicDetails)
    }
    
    func getTitle() -> String {
        return selectedComic.title == selectedComic.safe_title ? selectedComic.title : selectedComic.safe_title
    }
    
    private func getTableViewHeaderView(contentTableView: UITableView) {
        contentTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.7)
    }
    
    private func setCompleteUrls() {
        completeUrlForSpesificComic = "\(imageLoader.spesificVisitUrl)\(selectedComic.num)"
        completeUrlForExplanation = "\(imageLoader.comicExplanationUrl)\(selectedComic.num)"
    }
    
    private func setupTableView(detailInfoTable: UITableView, delegateListener: NSObject) {
        setupNibs(detailInfoTable: detailInfoTable)
        detailInfoTable.dataSource = (delegateListener as! UITableViewDataSource)
        detailInfoTable.delegate = (delegateListener as! UITableViewDelegate)
        detailInfoTable.estimatedRowHeight = 70
        detailInfoTable.rowHeight = UITableView.automaticDimension
        detailInfoTable.separatorStyle = .none
    }
    
    private func setUpScrollView(imageZoomScrollView: UIScrollView, delegateListener: NSObject) {
        imageZoomScrollView.delegate = (delegateListener as! UIScrollViewDelegate)
        imageZoomScrollView.maximumZoomScale = 10
        imageZoomScrollView.minimumZoomScale = 1
    }
    
    private func setupNibs(detailInfoTable: UITableView) {
        let anyTextNib = UINib(nibName: "AnyTextCellNib", bundle: nil)
        detailInfoTable.register(anyTextNib, forCellReuseIdentifier: "anyTextID")
        
        let optionsButtonCellNib = UINib(nibName: "OptionsButtonCellNib", bundle: nil)
        detailInfoTable.register(optionsButtonCellNib, forCellReuseIdentifier: "optionsButtonCellID")
        
        let headerFooterViewNib = UINib(nibName: "ComicDetailHeaderFooterView", bundle: nil)
        detailInfoTable.register(headerFooterViewNib, forHeaderFooterViewReuseIdentifier: "comicDetailHeaderFooterView")
    }
    
    private func createCellContent(descriptionLbl: UILabel) {
        descriptionLbl.text = selectedComic.alt
        
        cellContent.append(ComicDetailsSection(contentDescription: "Release date", content: ["\(selectedComic.day)/\(selectedComic.month)/\(selectedComic.year)"]))
        if selectedComic.news != "" {
            cellContent.append(ComicDetailsSection(contentDescription: "News", content: [selectedComic.news]))
        }
        
        if selectedComic.transcript != "" {
            cellContent.append(ComicDetailsSection(contentDescription: "Transcript", content: [selectedComic.transcript]))
        }
        cellContent.append(ComicDetailsSection(contentDescription: "", content: ["Visit website"], isRedirectable: true))
        cellContent.append(ComicDetailsSection(contentDescription: "", content: ["Visit explanation"], isRedirectable: true))
    }
    
    private func getComicImage(comicImage: UIImageView) {
        imageLoader.loadImage(url: selectedComic.img) { (image) in
            guard let theImage = image else {return}
            comicImage.image = theImage
        }
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name.init("reChechIsFavorite"), object: nil, userInfo: ["comic": selectedComic as Any])
    }
    
    private func startListeningForFavoriteChange(listener: ComicDetails) {
        NotificationCenter.default.addObserver(listener, selector: #selector(listener.reChech(notification:)), name: NSNotification.Name.init("reChechIsFavorite"), object: nil)
    }
    
}
