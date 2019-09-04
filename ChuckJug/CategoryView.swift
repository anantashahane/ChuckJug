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
        SetupManagedObject()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        // Do any additional setup after loading the view.
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


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if let category = self.resultsController.fetchedObjects?[indexPath.row] {
            cell.SetupCell(for: category)
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
            break
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
        return CGSize(width: 200 , height: 200)
    }
    
}
