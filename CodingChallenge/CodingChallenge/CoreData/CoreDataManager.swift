//
//  CoreDataManager.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate {
    
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<FavoriteComic>!
    var fetchResultController: NSFetchedResultsController<FavoriteComic>!
    var updateFavoriteComicDelegate: UpdateFavoriteComicDelegate?
    
    override init() {
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        fetchRequest = NSFetchRequest<FavoriteComic>.init(entityName: "FavoriteComic")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "num", ascending: true)]
        fetchResultController = NSFetchedResultsController<FavoriteComic>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    /*
        Get all comics saved
     */
    
    func getAllComics() -> [Comic] {
        let allFavoriteComics = try! context.fetch(fetchRequest)
        return convertFavoritesToComics(favoriteComics: allFavoriteComics)
    }
    
    /*
        Converting an array og favoriteComics to an array of Comics and returns the array of Comics
     */
    
    private func convertFavoritesToComics(favoriteComics: [FavoriteComic]) -> [Comic] {
        var allComics = [Comic]()
        for favoriteComic in favoriteComics {
            if let convertedComic = favoriteComic.convertToComic() {
                allComics.append(convertedComic)
            }
        }
        return allComics
    }
    
    /*
        Returning the result of if the comic extists or not
     */
    func checkIfComicIsSaved(comic: Comic) -> Bool {
        let favoriteComics = try! context.fetch(fetchRequest)
        for favoriteComic in favoriteComics {
            if Int(favoriteComic.num) == comic.num {
                return true
            }
        }
        return false
    }
    
    /*
        Saving a comic to coredata
     */
    func addComic(comic: Comic, imageData: Data) {
        _ = FavoriteComic(result: comic.createDictionaryForSaving(imageData: imageData), managedObjectContext: context)
        appDelegate.saveContext()
    }
    
    /*
        Removing comic from coredata
     */
    func removeComic(comic: Comic) {
        let favoriteComics = try! context.fetch(fetchRequest)
        for favoriteComic in favoriteComics {
            if Int(favoriteComic.num) == comic.num {
                context.delete(favoriteComic)
                appDelegate.saveContext()
                break
            }
        }
    }
    
    /*
        Setting the delegate to the listener for coredata updates.
        To get data at once, the current data is fetched and the listener are updated.
     */
    func setDelegate(viewControllerListener: NSObject) {
        fetchResultController.delegate = self
        updateFavoriteComicDelegate = viewControllerListener as? UpdateFavoriteComicDelegate
        do {
            try fetchResultController.performFetch()
        } catch let error as NSError {
            print("Could not load comics: \(error)")
        } 
        runUpdateDelegate()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        runUpdateDelegate()
    }
    
    /*
        This method is retrieving the objects in coredata for the spesific table.
        The data is sent to the listener.
     */
    private func runUpdateDelegate() {
        if let favoriteObjects = fetchResultController.fetchedObjects {
            updateFavoriteComicDelegate?.update(comics: convertFavoritesToComics(favoriteComics: favoriteObjects))
        } else {
            updateFavoriteComicDelegate?.update(comics: [])
        }
    }
    
}
