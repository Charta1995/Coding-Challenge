//
//  FavoriteComicTests.swift
//  CodingChallengeTests
//
//  Created by Marius Fagerhol on 30/06/2019.
//  Copyright © 2019 Marius Fagerhol. All rights reserved.
//

import Foundation
import XCTest
import CoreData

@testable import CodingChallenge
class FavoriteComicTests: XCTestCase {
    
    private let coreDataManager = CoreDataManager()
    private var results = [String: Any]()
    private let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private var context: NSManagedObjectContext!
    private var comic: Comic?
    
    private func setup() {
        context = appDelegate.persistentContainer.viewContext
        XCTAssertNotNil(context)
        results = ["month": "02", "num": 1, "link": "", "year": "2019", "news": "", "safe_title": "Test safe title", "transcript": "Test transcript", "alt": "An alt", "img": "https://via.placeholder.com/150", "title": "Test title", "day": "01", "imageData": Data()]
    }
    
    private func testAdd() {
        setup()
        let favoriteComic = FavoriteComic(result: results, managedObjectContext: context)
        comic = favoriteComic?.convertToComic()
        XCTAssertNotNil(comic)
        XCTAssertTrue(coreDataManager.checkIfComicIsSaved(comic: comic!))
    }
    
    private func testRemove() {
        setup()
        testAdd()
        coreDataManager.removeComic(comic: comic!)
        XCTAssertTrue(!coreDataManager.checkIfComicIsSaved(comic: comic!))
    }
    
    private func testGetAll() {
        setup()
        testAdd()
        let favoriteList = coreDataManager.getAllComics()
        XCTAssertTrue(!favoriteList.isEmpty)
    }
    
}
