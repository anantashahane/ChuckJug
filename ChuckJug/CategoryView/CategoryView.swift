//
//  CategoryView.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit

class CategoryView: UICollectionViewController {

    var Categories : [String]?
    var SegueData : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetCategories()
        // Do any additional setup after loading the view.
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
                        self.Categories = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch let err {
                        print("Serialisation Error: \(err.localizedDescription)")
                    }
                    
                }
            }.resume()
        }
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Categories?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
        if let category = Categories?[indexPath.row] {
            cell.setupViewCell(for: category)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.SegueData = Categories?[indexPath.row] ?? "unknown"
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
