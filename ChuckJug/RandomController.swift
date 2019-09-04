//
//  RandomController.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class RandomController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var resultsController : NSFetchedResultsController<JokeData>!
    var context : NSManagedObjectContext!
    var refresher : UIRefreshControl!
    var Categories : [String : Categories]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.tableView.register(UINib(nibName: "JokeCard", bundle: nil), forCellReuseIdentifier: "JokeCard")
        
        FetchCategories()
        
        if let categories = Categories {
            if categories.count <= 3 {
                SaveCategories()
                FetchCategories()
            }
        }
        SetResultsController()
        SetupUI()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }
    
    func SaveCategories() {
        if let categories = GetCategories() {
            print("Categories = \(categories)")
            for category in categories {
                let persistentCategory = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context)
                persistentCategory.setValue(category, forKey: "category")
                do {
                    try self.context.save()
                } catch let err {
                    print("Error saving category \(err.localizedDescription)")
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCard", for: indexPath) as! JokeCard
        let cellData = self.resultsController.fetchedObjects?[indexPath.row]
        if let cellData = cellData {
            cell.SetupCell(for: cellData)
        }
        cell.delegate = self
        return cell
    }
    
    
    
    func SetupUI() {
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RandomController.AddJokeToTable), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refresher)
    }
    
    @objc func AddJokeToTable() {
        let Joke = GetJoke(nil)
        print(Joke ?? "Noting really came")
        let JokeCache = NSEntityDescription.insertNewObject(forEntityName: "JokeData", into: context)
        do {
            if let Joke = Joke {
                JokeCache.setValue(Joke.id, forKey: "jokeid")
                JokeCache.setValue(Joke.value, forKey: "joke")
                JokeCache.setValue(false, forKey: "favourite")
                JokeCache.setValue(Date.init(timeIntervalSinceNow: 0), forKey: "added")
                if let localCategories = self.Categories {
                    if let jokeCategories = Joke.category {
                        for eachCategory in jokeCategories {
                            localCategories[eachCategory]?.addToJoke(JokeCache as! JokeData)
                            localCategories[eachCategory]?.mutableSetValue(forKey: "joke").add(JokeCache)
                        }
                    }
                    else {
                        localCategories["unknown"]?.addToJoke(JokeCache as! JokeData)
                        localCategories["unknown"]?.mutableSetValue(forKey: "joke").add(JokeCache)
                    }
                }
            }
            try context.save()
        }
        catch let err {
            print("Error saving joke \(err.localizedDescription)")
        }
        self.refresher.endRefreshing()
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
    
    func SetResultsController() {
        let fetchRequest = NSFetchRequest<JokeData>(entityName: "JokeData")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "added", ascending: false)]
        
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
            self.tableView.deleteRows(at: [indexPath!], with: .none)
            self.tableView.insertRows(at: [newIndexPath!], with: .none)
            break
        default:
            break
        }
    }
}

extension RandomController : JokeCardDelegate {
    func ClickedOptions(on Joke: JokeData) {
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: "EditCategory") as! EditCategoryController
        destinationVC.jokeData = Joke
        destinationVC.categoryList = self.Categories
        destinationVC.context = self.context
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func ClickedLike(on Joke: JokeData) {
        Joke.favourite.toggle()
        if Joke.favourite == true {
            Joke.favoured = Date(timeIntervalSinceNow: 0) as NSDate
        }
        do {
            try self.context.save()
        }
        catch let err {
            print("Error \(err.localizedDescription)")
        }
    }
    
    func ClickedShare(on Joke: String) {
        let Share = UIActivityViewController(activityItems: [Joke], applicationActivities: nil)
        Share.popoverPresentationController?.sourceView = self.view
        self.present(Share, animated: true, completion: nil)
    }
}
