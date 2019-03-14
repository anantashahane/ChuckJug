//
//  CategorisedView.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData
class CategorisedView: UITableViewController, NSFetchedResultsControllerDelegate {

    var Category : String?
    var resultsController : NSFetchedResultsController<JokeData>!
    var context : NSManagedObjectContext!
    var refresher : UIRefreshControl!
    var Categories : [String : Categories]?
    
    struct Joke : Codable {
        let category : [String]?
        let icon_url : URL
        let id : String
        let url : URL
        let value : String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        FetchCategories()
        SetResultsController()
        SetupUI()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategorisedCell
        let cellData = self.resultsController.fetchedObjects?[indexPath.row]
        if let cellData = cellData {
            cell.SetupCell(for: cellData)
        }
        cell.delegate = self
        return cell
    }

    @objc func GetJoke() {
        var url : URL?
        if Category == "unknown" {
            url = URL(string: "https://api.chucknorris.io/jokes/random")
        } else {
            url = URL(string: "https://api.chucknorris.io/jokes/random?category=\(Category!)")
        }
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                print( "Fetch error: \(error.localizedDescription) \n Response type: \(String(describing: response))")
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let parsedData = try decoder.decode(Joke.self, from: data)
                    let newJoke = NSEntityDescription.insertNewObject(forEntityName: "JokeData", into: self.context)
                    newJoke.setValue(parsedData.id, forKey: "jokeid")
                    newJoke.setValue(parsedData.value, forKey: "joke")
                    newJoke.setValue(false, forKey: "favourite")
                    newJoke.setValue(Date.init(timeIntervalSinceNow: 0), forKey: "added")
                    if let categories = parsedData.category {
                        if let localCategories = self.Categories {
                            for Parsedcategory in categories {
                                localCategories[Parsedcategory]?.addToJoke(newJoke as! JokeData)
                            }
                        } else {
                            for category in categories {
                                let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: self.context)
                                newCategory.setValue(category, forKey: "category")
                                newCategory.mutableSetValue(forKey: "joke").add(newJoke)
                            }
                        }
                    } else {
                        if let localCategories = self.Categories {
                            localCategories["unknown"]?.addToJoke(newJoke as! JokeData)
                        } else {
                            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: self.context)
                            newCategory.setValue("unknown", forKey: "category")
                            newCategory.mutableSetValue(forKey: "joke").add(newJoke)
                        }
                    }
                    try self.context.save()
                }
                catch let err {
                    print("Decoding/Saving error: \(err.localizedDescription)")
                    return
                }
            }
            }.resume()
        refresher.endRefreshing()
    }
    
    func FetchCategories() {
        let categoryRequest = NSFetchRequest<Categories>.init(entityName: "Categories")
        categoryRequest.sortDescriptors = [NSSortDescriptor.init(key: "category", ascending: true)]
        let controller = NSFetchedResultsController.init(fetchRequest: categoryRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
        if let fetchedObjects = controller.fetchedObjects {
            self.Categories = [:]
            for object in fetchedObjects {
                self.Categories?[object.category!] = object
            }
        }
    }
    
    func SetupUI() {
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RandomController.GetJoke), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refresher)
        self.navigationItem.title = self.Category?.uppercased()
    }
    
    func SetResultsController() {
        let fetchRequest = NSFetchRequest<JokeData>(entityName: "JokeData")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "added", ascending: false)]
        fetchRequest.predicate = NSPredicate.init(format: "ANY categories.category CONTAINS[cd] %@", (Category ?? "unknown"))
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.resultsController.performFetch()
        }
            
        catch let err {
            print("Fetch error: \(err.localizedDescription)")
            return
        }
        self.resultsController.delegate = self
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .top)
            break
        case NSFetchedResultsChangeType.delete:
            self.tableView.deleteRows(at: [indexPath!], with: .bottom)
            break
        case NSFetchedResultsChangeType.move:
            self.tableView.deleteRows(at: [indexPath!], with: .bottom)
            self.tableView.insertRows(at: [newIndexPath!], with: .top)
            break
        case NSFetchedResultsChangeType.update:
            self.tableView.deleteRows(at: [indexPath!], with: .bottom)
            self.tableView.insertRows(at: [newIndexPath!], with: .top)
            break
        default:
            break
        }
    }
}

extension CategorisedView : CategorisedCellDelegate {
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

