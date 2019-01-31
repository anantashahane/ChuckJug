//
//  CategoryCell.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var Background: UIImageView!
    @IBOutlet weak var CategoryName: UILabel!
    
    let BackGroundImage = ["explicit" : UIImage.init(named: "explicit"),
                           "dev" : UIImage.init(named: "dev"),
                           "movie": UIImage.init(named: "movie"),
                           "food": UIImage.init(named: "food"),
                           "celebrity": UIImage.init(named: "celebrity"),
                           "science" : UIImage.init(named: "science"),
                           "sport" : UIImage.init(named: "sport"),
                           "political" : UIImage.init(named: "political"),
                           "religion" : UIImage.init(named: "religion"),
                           "animal" : UIImage.init(named: "animal"),
                           "history" : UIImage.init(named: "history"),
                           "music" : UIImage.init(named: "music"),
                           "travel" : UIImage.init(named: "travel"),
                           "career" : UIImage.init(named: "career"),
                           "money" : UIImage.init(named: "money"),
                           "fashion" : UIImage.init(named: "fashion"),
                           "unknown" : UIImage.init(named: "unknown")]
    
    public func setupViewCell(for category: String) {
        if let bmi = BackGroundImage[category] {
            self.Background.image = bmi
        }
        self.CategoryName.text = category.uppercased()
        self.layer.cornerRadius = 32
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
