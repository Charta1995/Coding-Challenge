//
//  CoreDataManager.swift
//  CodingChallenge
//
//  Created by Marius Fagerhol on 29/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateFavoriteComicDelegate {
    func update(comics: [Comic])
}

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
    
    func getAllComics() -> [Comic] {
        let allFavoriteComics = try! context.fetch(fetchRequest)
        return convertFavoritesToComics(favoriteComics: allFavoriteComics)
    }
    
    private func convertFavoritesToComics(favoriteComics: [FavoriteComic]) -> [Comic] {
        var allComics = [Comic]()
        for favoriteComic in favoriteComics {
            if let convertedComic = favoriteComic.convertToComic(instance: favoriteComic) {
                allComics.append(convertedComic)
            }
        }
        return allComics
    }
    
    func checkIfComicIsSaved(comic: Comic) -> Bool {
        let favoriteComics = try! context.fetch(fetchRequest)
        for favoriteComic in favoriteComics {
            if Int(favoriteComic.num) == comic.num {
                return true
            }
        }
        return false
    }
    
    func addComic(comic: Comic, imageData: Data) {
        _ = FavoriteComic(result: comic.createDictionaryForSaving(imageData: imageData), managedObjectContext: context)
        appDelegate.saveContext()
    }
    
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
    
    func setDelegate(viewControllerListener: UIViewController) {
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
    
    private func runUpdateDelegate() {
        if let favoriteObjects = fetchResultController.fetchedObjects {
            updateFavoriteComicDelegate?.update(comics: convertFavoritesToComics(favoriteComics: favoriteObjects))
        } else {
            updateFavoriteComicDelegate?.update(comics: [])
        }
    }
    
}
