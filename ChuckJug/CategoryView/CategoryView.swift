//
//  CategoryView.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class CategoryView: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var context : NSManagedObjectContext!
    var resultsController : NSFetchedResultsController<Categories>!

    var refresher : UIControl!
    var SegueData : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetCategories()
        SetupManagedObject()
        // Do any additional setup after loading the view.
        GetCategories()
    }

    func SetupManagedObject() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let fetchRequest = NSFetchRequest<Categories>(entityName: "Categories")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "category", ascending: true)]
        self.resultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try self.resultsController.performFetch()
        }
        catch let err {
            print(err.localizedDescription)
        }
        self.resultsController.delegate = self
    }
    
    func GetCategories() {
        let url = URL(string: "https://api.chucknorris.io/jokes/categories")
        if let url = url {
            URLSession.shared.dataTask(with: url) {(data, response, err) in
                if let err = err {
                    print("error: \(err.localizedDescription) \n response : \(String(describing: response))")
                    return
                }
                if let data = data {
                    do {
                        var categories = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                        categories?.append("unknown")
                        self.SaveData(for: categories)
                    } catch let err {
                        print("Serialisation Error: \(err.localizedDescription)")
                    }
                    
                }
            }.resume()
        }
    }

    func SaveData(for Categories : [String]?) {
        if var Categories = Categories {
            Categories.sort()
            var savedCategories : [String] = []
            for savedCategory in self.resultsController.fetchedObjects! {
                savedCategories.append(savedCategory.category!)
            }
            Categories = Categories.filter { return !savedCategories.contains($0)}
            print(Categories)
            for category in Categories {
                let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: self.context)
                newCategory.setValue(category, forKey: "category")
                do {
                    try self.context.save()
                }
                catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
        if let category = self.resultsController.fetchedObjects?[indexPath.row] {
            cell.setupViewCell(for: category)
        }
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [newIndexPath!])
            }, completion: nil)
            break
        case NSFetchedResultsChangeType.move:
            collectionView.performBatchUpdates({
                collectionView.moveItem(at: indexPath!, to: newIndexPath!)
            }, completion: nil)
            break
        case NSFetchedResultsChangeType.delete:
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath!])
            }, completion: nil)
            break
        case NSFetchedResultsChangeType.update:
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath!])
                collectionView.insertItems(at: [newIndexPath!])
            }, completion: nil)
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.SegueData = self.resultsController.fetchedObjects?[indexPath.row].category ?? "unknown"
        performSegue(withIdentifier: "Categorised", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let CategorisedVC = segue.destination as! CategorisedView
        CategorisedVC.Category = self.SegueData
    }
}

extension CategoryView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2.2 , height: self.view.frame.width/2.2)
    }
    
}
