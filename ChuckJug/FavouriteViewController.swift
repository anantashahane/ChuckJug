//
//  FavouriteViewController.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 12/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var resultsController : NSFetchedResultsController<JokeData>!
    
    var context : NSManagedObjectContext!
    var refresher : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = AppDelegate.persistentContainer.viewContext
        
        FetchData()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.resultsController.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FavouriteViewCell
        let celldata = self.resultsController.fetchedObjects?[indexPath.row]
        if let celldata = celldata {
            cell.Initiate(celldata)
        }
        cell.delegate = self
        return cell
    }

    func FetchData() {
        let fetchRequest = NSFetchRequest<JokeData>(entityName: "JokeData")
        // Configure the request's entity, and optionally its predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "jokeid", ascending: true)]
        fetchRequest.predicate = NSPredicate.init(format: "favourite == \(true)")
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try self.resultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        self.resultsController.delegate = self
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }

}

extension FavouriteViewController : FavouriteViewCellDelegate {
    
    func didTapShare(joke: String) {
        let Share = UIActivityViewController(activityItems: [joke], applicationActivities: nil)
        Share.popoverPresentationController?.sourceView = self.view
        self.present(Share, animated: true, completion: nil)
    }
    
    func didTapFavourite(Joke: JokeData) {
        for object in self.resultsController.fetchedObjects as! [JokeData] {
            if object.jokeid == Joke.jokeid {
                object.favourite = Joke.favourite
                do {
                    try self.context.save()
                }
                catch let err{
                    print("Error saving: \(err)")
                }
                
            }
        }
    }
    
}

extension FavouriteViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
}
