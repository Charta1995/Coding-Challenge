//
//  ComicDetails.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

protocol OptionsButtonWasTapped {
    func addToFavoriteTapped()
    func shareTapped()
}

class ComicDetails: UIViewController {
    
    @IBOutlet weak var detailInfoTable: UITableView!
    @IBOutlet weak var imageZoomScrollVie: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDescription: UILabel!
    
    var selectedComic: Comic!
    var cellContent = [ComicDetailsSection]()
    private let imageLoader = ImageLoader()
    private var completeUrlForSpesificComic: String!
    private var completeUrlForExplanation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedComic.title == selectedComic.safe_title ? selectedComic.title : selectedComic.safe_title
        detailInfoTable.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.7)
        
        completeUrlForSpesificComic = "\(imageLoader.spesificVisitUrl)\(selectedComic.num)/)"
        completeUrlForExplanation = "\(imageLoader.comicExplanationUrl)\(selectedComic.num)"
        
        createCellContent()
        setupTableView()
        setUpScrollView()
        getComicImage()
    }
    
    private func setupTableView() {
        detailInfoTable.dataSource = self
        detailInfoTable.delegate = self
        detailInfoTable.estimatedRowHeight = 70
        detailInfoTable.rowHeight = UITableView.automaticDimension
        detailInfoTable.separatorStyle = .none
        setupNibs()
    }
    
    private func setUpScrollView() {
        imageZoomScrollVie.delegate = self
        imageZoomScrollVie.maximumZoomScale = 10
        imageZoomScrollVie.minimumZoomScale = 1
    }
    
    private func setupNibs() {
        let anyTextNib = UINib(nibName: "AnyTextCellNib", bundle: nil)
        detailInfoTable.register(anyTextNib, forCellReuseIdentifier: "anyTextID")
        
        let optionsButtonCellNib = UINib(nibName: "OptionsButtonCellNib", bundle: nil)
        detailInfoTable.register(optionsButtonCellNib, forCellReuseIdentifier: "optionsButtonCellID")
        
        let headerFooterViewNib = UINib(nibName: "ComicDetailHeaderFooterView", bundle: nil)
        detailInfoTable.register(headerFooterViewNib, forHeaderFooterViewReuseIdentifier: "comicDetailHeaderFooterView")
    }
    
    private func createCellContent() {
        comicDescription.text = selectedComic.alt
        
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
    
    private func getComicImage() {
        imageLoader.loadImage(url: selectedComic.img) { (image) in
            guard let theImage = image else {return}
            self.comicImage.image = theImage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWebController" {
            if let theUrl = sender as? String {
                if let destinationViewController = segue.destination as? WebViewController {
                    destinationViewController.url = theUrl
                }
            }
        }
    }
    
}

extension ComicDetails: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellContent.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsButtonCellID") as! OptionsButtonCell
            cell.configureCell(comicDetails: self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "anyTextID") as! AnyTextCell
            cell.configureCell(text: cellContent[indexPath.section - 1].content[0], isRedirectable: cellContent[indexPath.section - 1].isRedirectable)
            return cell
        }
    }
}

extension ComicDetails: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == cellContent.count {
            return 1
        } else {
            if section > 0 {
                if cellContent[section - 1].contentDescription != "" {
                    return 40
                }
            }
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "comicDetailHeaderFooterView") as! ComicDetailHeaderFooterView
        if section > 0 {
            headerFooterView.configureHeaderFooterView(text: cellContent[section - 1].contentDescription)
        } else {
            headerFooterView.configureHeaderFooterView(text: "")
        }
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let cellText = cellContent[indexPath.section - 1].content[indexPath.row]
            switch cellText {
            case "Visit website":
                performSegue(withIdentifier: "goToWebController", sender: completeUrlForSpesificComic)
                break
            case "Visit explanation":
                performSegue(withIdentifier: "goToWebController", sender: completeUrlForExplanation)
                break
            default: break}
        }
    }
}
 
extension ComicDetails: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return comicImage
    }
}

extension ComicDetails: OptionsButtonWasTapped {
    func addToFavoriteTapped() {
        print("Add to favorite")
    }
    
    func shareTapped() {
        let shareActivity = UIActivityViewController(activityItems: selectedComic.getContentToShare(image: comicImage.image, comicOnWeb: completeUrlForSpesificComic, comicExplantaion: completeUrlForExplanation), applicationActivities: nil)
        shareActivity.popoverPresentationController?.sourceView = view
        present(shareActivity, animated: true, completion: nil)
    }
}
