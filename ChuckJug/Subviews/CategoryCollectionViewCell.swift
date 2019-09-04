//
//  CategoryCollectionViewCell.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var backPlate: UIView!
    
    var category : Categories!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetupCell(for Category : Categories) {
        self.category = Category
        
        self.backPlate.backgroundColor = colorScheme[Category.category ?? "unknown"]?.background
        self.backPlate.layer.cornerRadius = 30

        self.CategoryLabel.text = Category.category ?? "unknown"
        self.CategoryLabel.textColor = colorScheme[Category.category ?? "unknown"]?.foreground
        
        backPlate.layer.shadowColor = colorScheme[Category.category ?? "unknown"]?.background.cgColor
        backPlate.layer.shadowOpacity = 0.5
        backPlate.layer.shadowOffset = .zero
        backPlate.layer.shadowRadius = 5
        
    }

}
