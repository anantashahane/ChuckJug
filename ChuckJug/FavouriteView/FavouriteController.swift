//
//  FavouriteController.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class FavouriteController: UITableViewController, NSFetchedResultsControllerDelegate {

    var resultsController : NSFetchedResultsController<JokeData>!
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        SetupCoreData()
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.resultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavouriteCell
        let cellData = self.resultsController.fetchedObjects?[indexPath.row]
        if let cellData = cellData {
            cell.SetupCell(for: cellData)
        }
        cell.delegate = self
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        default:
            break
        }
    }

    func SetupCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<JokeData>(entityName: "JokeData")
        fetchRequest.predicate = NSPredicate.init(format: "favourite == \(true)")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "favoured", ascending: false)]
        
        self.resultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.resultsController.performFetch()
        }
        catch let error {
            print("Fetching Error: \(error.localizedDescription)")
            return
        }
        self.resultsController.delegate = self
    }
}

extension FavouriteController : FavouriteCellDelegate {
    func didClickedFavourite(for Joke: JokeData) {
        for object in self.resultsController.fetchedObjects! {
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
    
    func didClickedAction(for Joke: String) {
        let Share = UIActivityViewController(activityItems: [Joke], applicationActivities: nil)
        Share.popoverPresentationController?.sourceView = self.view
        self.present(Share, animated: true, completion: nil)
    }
    
    
}
