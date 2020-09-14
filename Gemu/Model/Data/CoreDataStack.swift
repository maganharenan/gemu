//
//  CoreDataStack.swift
//  Gemu
//
//  Created by Renan Maganha on 06/09/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI
import CoreData

class CoreDataStack {
    
    init() {
        
    }
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var viewContext: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    //MARK: Insert Methods
    
    func addAllGameDataToDatabase(gameData: GameResponse, coverURL: String, platform: PlatformResponse, wishList: Bool, collection: Bool, played: Bool, playing: Bool, completed: Bool) {
        checkIfPlatformExistsInStore(name: platform.name ?? "") { (response) in
            if let platform = response {
                self.addGameToDatabase(gameData: gameData, coverURL: coverURL, platform: platform) { game in
                    self.addGameListInformation(game: game, wishList: wishList, collection: collection, played: played, playing: playing, completed: completed)
                }
            } else {
                self.addPlatformToDatabase(platform: platform) { response in
                     self.addGameToDatabase(gameData: gameData, coverURL: coverURL, platform: response) { game in
                        self.addGameListInformation(game: game, wishList: wishList, collection: collection, played: played, playing: playing, completed: completed)
                    }
                }
            }
        }
    }
    
    func addPlatformToDatabase(platform: PlatformResponse, completion: @escaping (Platform) -> Void) {
        let newPlatform = Platform(context: viewContext)
        newPlatform.abbreviation = platform.abbreviation
        newPlatform.alternativeName = platform.alternativeName
        newPlatform.name = platform.name
        appDelegate.saveContext()
        completion(newPlatform)
    }
    
    func addGameToDatabase(gameData: GameResponse, coverURL: String, platform: Platform, completion: @escaping (Game) -> Void) {
        let newGame = Game(context: viewContext)
        newGame.name = gameData.name
        newGame.summary = gameData.summary
        newGame.storyline = gameData.storyline
        newGame.cover = NSData(data: downloadGameCover(url: coverURL) ?? Data()) as Data
        newGame.platform = platform
        appDelegate.saveContext()
        completion(newGame)
    }
    
    func addGameListInformation(game: Game, wishList: Bool, collection: Bool, played: Bool, playing: Bool, completed: Bool) {
        let newGameLists = ListData(context: viewContext)
        newGameLists.wishlist = wishList
        newGameLists.collection = collection
        newGameLists.played = played
        newGameLists.playing = playing
        newGameLists.completed = completed
        game.setValue(newGameLists, forKey: "lists")
        appDelegate.saveContext()
    }
    
    func downloadGameCover(url: String) -> Data? {
        let urlWithSize = url.replacingOccurrences(of: "t_thumb", with: "t_cover_big_2x")
        var dataImage = Data()
        let syncTask = DispatchGroup()
        syncTask.enter()
        IGDBClient().taskForDownloadRequest(url: urlWithSize) { (data, error) in
            if let data = data {
                dataImage = data
                syncTask.leave()
            } else {
                syncTask.leave()
            }
        }
        syncTask.wait()
        return dataImage
    }
    
    func fetchAllGameData(completion: @escaping (NSFetchedResultsController<Game>?, Error?) -> Void) {
        var fetchedResultsController: NSFetchedResultsController<Game>!
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: "games")
        
        do {
            try fetchedResultsController.performFetch()
            completion(fetchedResultsController, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func fetchPlatformData(completion: @escaping (NSFetchedResultsController<Platform>?, Error?) -> Void) {
        var fetchedResultsController: NSFetchedResultsController<Platform>!
        let fetchRequest: NSFetchRequest<Platform> = Platform.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: "platforms")
        
        do {
            try fetchedResultsController.performFetch()
            completion(fetchedResultsController, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func checkIfPlatformExistsInStore(name: String, completion: @escaping (Platform?) -> Void) {
        let predicate = NSPredicate(format: "name == %@", name)
        var platform: Platform?
        do {
            try platform = fetchSpecificPlatform(predicate, entityName: "Platform")
            completion(platform)
        } catch {
            print("Error: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    ///Try to fetch the results of a specific pin and returns it
    func fetchSpecificPlatform(_ predicate: NSPredicate, entityName: String, sortDescriptor: NSSortDescriptor? = nil) throws -> Platform? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        guard let pin = (try viewContext.fetch(fetchRequest) as! [Platform]).first else {
            return nil
        }
        return pin
    }
}
