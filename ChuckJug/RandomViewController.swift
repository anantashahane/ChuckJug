//
//  RandomViewController.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 12/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class RandomViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var context : NSManagedObjectContext!
    var refresher : UIRefreshControl!
    
    var resultsController : NSFetchedResultsController<JokeData>!
    
    struct JsonParser : Decodable {
        let category: [String]?
        let icon_url : URL
        let id : String
        let url : URL
        let value : String
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.context = AppDelegate.persistentContainer.viewContext
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RandomViewController.GetData), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresher)
        self.collectionView.alwaysBounceVertical = true
        
        GetData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! JokeCell
        let celldata = self.resultsController.fetchedObjects?[indexPath.row]
        if let celldata = celldata {
            cell.Initiate(celldata)
        }
        cell.delegate = self
        return cell
    }
    
    
    
    @objc func GetData() {
        let JokeFetchURLString = "https://api.chucknorris.io/jokes/random"
        guard let JokeFetchURL = URL(string: JokeFetchURLString) else {return}
        
        URLSession.shared.dataTask(with: JokeFetchURL) {(data, _, err) in
            DispatchQueue.main.async {
                if (err != nil) {
                    print("GetData() error: ", err!)
                    return
                }
                
                guard let data = data else {return}
          
                do {
                    let Decoder = JSONDecoder()
                    let jsonParsedData = try Decoder.decode(JsonParser.self, from: data)
                    let newJoke = NSEntityDescription.insertNewObject(forEntityName: "JokeData", into: self.context)
                    newJoke.setValue(jsonParsedData.id, forKey: "jokeid")
                    newJoke.setValue(jsonParsedData.value, forKey: "joke")
                    newJoke.setValue(jsonParsedData.category, forKey: "category")
                    newJoke.setValue(false, forKey: "favourite")
                    try self.context.save()
                
                } catch let jsonErr {
                    print("GetData.Parsing error: \(jsonErr.localizedDescription)")
                }
                
            }
        }.resume()
        refresher.endRefreshing()
    }
    
    func FetchData() {
        let fetchRequest = NSFetchRequest<JokeData>(entityName: "JokeData")
        // Configure the request's entity, and optionally its predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "jokeid", ascending: true)]
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
        try self.resultsController.performFetch()
        } catch {
        fatalError("Failed to fetch entities: \(error)")
        }
        self.resultsController.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let indexPath = indexPath {
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: [indexPath])
                }, completion: nil)
            }
            break
        case NSFetchedResultsChangeType.update:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    self.collectionView.performBatchUpdates({
                        self.collectionView.deleteItems(at: [indexPath])
                        self.collectionView.insertItems(at: [newIndexPath])
                    }, completion: nil)
                }
            }
            break
        case NSFetchedResultsChangeType.delete:
            if let indexPath = indexPath {
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [indexPath])
                }, completion: nil)
            }
            break
        default:
            self.collectionView.reloadData()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }
    
}

extension RandomViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
}

extension RandomViewController : JokeCellDelegate {
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
    
    
    func didTapShare(joke: String) {
        let Share = UIActivityViewController(activityItems: [joke], applicationActivities: nil)
        Share.popoverPresentationController?.sourceView = self.view
        self.present(Share, animated: true, completion: nil)
    }

}


