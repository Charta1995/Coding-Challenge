//
//  ComicDetails.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 28/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit

class ComicDetails: UIViewController {
    
    @IBOutlet weak var detailInfoTable: UITableView!
    @IBOutlet weak var imageZoomScrollVie: UIScrollView!
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicDescription: UILabel!
    
    private var comicDetailHelper: ComicDetailHelper!
    
    var selectedComic: Comic!
    var cellContent = [ComicDetailsSection]()
    private let coreDataManager = CoreDataManager()
    private let alerts = Alerts()
    private var isFavorite: Bool!
    private var shouldCheckForUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
            Setting up
         */
        comicDetailHelper = ComicDetailHelper(selectedComic: selectedComic, contentTable: detailInfoTable, imageZoomScrollView: imageZoomScrollVie, descriptionLbl: comicDescription, comicImage: comicImage, delegateListener: self)
        title = comicDetailHelper.getTitle()
        checkIfFavorite()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldCheckForUpdate {
            justToggleAndReload()
            shouldCheckForUpdate = false
        }
    }
    
    /*Checking if there is any need to update add favorite button*/
    @objc func reChech(notification: NSNotification) {
        if let theUserInfo = notification.userInfo as NSDictionary? {
            if let comic = theUserInfo["comic"] as? Comic {
                shouldCheckForUpdate = comic.num == selectedComic.num
            }
        }
    }
    
    /*Checks if the comic is already a favorite and configures the add favorite button*/
    private func checkIfFavorite() {
        isFavorite = coreDataManager.checkIfComicIsSaved(comic: selectedComic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DataService.instance.segueToVisitComicWebsite {
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
        return comicDetailHelper.cellContent.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DataService.instance.optionButtonsNibId) as! OptionsButtonCell
            cell.configureCell(comicDetails: self, isFavorite: isFavorite)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DataService.instance.anyTextNibId) as! AnyTextCell
            cell.configureCell(text: comicDetailHelper.cellContent[indexPath.section - 1].content[0], isRedirectable: comicDetailHelper.cellContent[indexPath.section - 1].isRedirectable)
            return cell
        }
    }
}

extension ComicDetails: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == comicDetailHelper.cellContent.count {
            return 1
        } else {
            if section > 0 {
                //If there is text
                if comicDetailHelper.cellContent[section - 1].contentDescription != "" {
                    return 40
                }
            }
        }
        //Just space
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DataService.instance.headerFooterViewNib) as! ComicDetailHeaderFooterView
        if section > 0 {
            //If there is text
            headerFooterView.configureHeaderFooterView(text: comicDetailHelper.cellContent[section - 1].contentDescription)
        } else {
            //Just space
            headerFooterView.configureHeaderFooterView(text: "")
        }
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let cellText = comicDetailHelper.cellContent[indexPath.section - 1].content[indexPath.row]
            switch cellText {
            case "Visit website":
                performSegue(withIdentifier: "goToWebController", sender: comicDetailHelper.completeUrlForSpesificComic)
                break
            case "Visit explanation":
                performSegue(withIdentifier: "goToWebController", sender: comicDetailHelper.completeUrlForExplanation)
                break
            default: break}
        }
    }
}

/* ScrollView methods */
extension ComicDetails {
    //Does the image zoomable.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return comicImage
    }
}

extension ComicDetails: OptionsButtonWasTapped {
    func deleteOrAddToFavoriteTapped(delete: Bool) {
        if delete {
            removeFromFavorite()
        } else {
            addToFavorite()
        }
    }
    
    private func addToFavorite() {
        if let theComicImage = comicImage.image {
            if let imageData = theComicImage.jpegData(compressionQuality: ImageCompressQuality.high.rawValue) {
                coreDataManager.addComic(comic: selectedComic, imageData: imageData)
                let favoriteChecked = coreDataManager.checkIfComicIsSaved(comic: selectedComic)
                toggleIsFavoriteAndReload(added: true, success: favoriteChecked)
            }
        }
    }
    
    private func removeFromFavorite() {
        coreDataManager.removeComic(comic: selectedComic)
        let existence = coreDataManager.checkIfComicIsSaved(comic: selectedComic)
        let success = !existence
        toggleIsFavoriteAndReload(added: false, success: success)
    }
    
    /*
        This method is updating the addFavorite button and sends message to other insances og this class to do the same if either delete or add to coredata was successful.
        An alert is displayed to show if the coredata operataion was successful or not
     */
    private func toggleIsFavoriteAndReload(added: Bool, success: Bool) {
        if success {
            justToggleAndReload()
            
            //Sending notification to all active instances of this class.
            comicDetailHelper.sendNotification()
        }
        let successMessage = added ? "\(self.title!) was added to your favorite list, you can access it in the favorite tab" : "\(self.title!) was removed from your favorite list"
        let errorMessage = added ? "\(self.title!) could not be added, try again later" : "\(self.title!) could not be removed, please try again later"
        let title = success ? "Success": "Error"
        let usingMessage = success ? successMessage : errorMessage
        present(alerts.presentStandardOKAlert(title: title, message: usingMessage, okActionTitle: "Ok"), animated: true, completion: nil)
    }
    
    /*
        Checking if the selected comic is still a favorite or not and updates the addFavoriteButton
     */
    private func justToggleAndReload() {
        checkIfFavorite()
        detailInfoTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    /*
        Opens a share dialog with selecedComic data in it.
     */
    func shareTapped() {
        let contentToShare = selectedComic.getContentToShare(image: comicImage.image, comicOnWeb: comicDetailHelper.completeUrlForSpesificComic, comicExplantaion: comicDetailHelper.completeUrlForExplanation)
        present(alerts.presentShareController(contentToShare: contentToShare, viewHolder: self.view), animated: true, completion: nil)
    }
}
