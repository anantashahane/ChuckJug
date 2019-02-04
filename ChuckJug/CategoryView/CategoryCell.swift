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
    
    public func setupViewCell(for category: Categories) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 100
        if let bmi = BackGroundImage[category.category!] {
            self.Background.image = bmi
        }
        let attributes0: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0),
            .font: UIFont(name: "HelveticaNeue-Bold", size: 15)!
        ]
        let attributedString = NSMutableAttributedString(string: category.category!.uppercased())
        attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: category.category!.count))
        
        self.CategoryName.attributedText = attributedString
        self.layer.cornerRadius = 32
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}
