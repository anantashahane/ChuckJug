//
//  EditCategoryController.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

class EditCategoryController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var jokeData : JokeData?
    var categoryList : [String : Categories]?
    var context : NSManagedObjectContext!
    var innitialCategory : String!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var CategoryLabel: UITextField!
    @IBOutlet weak var CardBackground: UIView!
    @IBOutlet weak var JokeLabel: UILabel!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet var BackgroundView: UIView!
    
    //Could not find a way to create string array from dictionary keys
    let PickerViewLabels = ["explicit", "dev", "movie", "food", "celebrity", "science", "sport", "political", "religion", "animal", "history", "music", "travel", "career", "money", "fashion", "unknown"].sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupPickerView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetupUI()
    }
    

    func SetupUI() {
        self.navigationItem.title = "Edit Category"
        
        let categoryText = jokeData!.categories.first?.category ?? "unknown"
        
        self.JokeLabel.text = jokeData!.joke
        self.CategoryLabel.text = categoryText.uppercased()
        
        if jokeData!.favourite == true {
            self.LikeButton.setImage(UIImage(named: "Liked"), for: .normal)
        }
        
        self.CardBackground.layer.cornerRadius = 30
        self.CardBackground.backgroundColor = colorScheme[categoryText]?.background
        
        self.BackgroundView.backgroundColor = colorScheme[categoryText]?.background.withAlphaComponent(0.5)
        
        self.CategoryLabel.textColor = colorScheme[categoryText]?.foreground
        self.JokeLabel.textColor = colorScheme[categoryText]?.foreground
        self.LikeButton.tintColor = colorScheme[categoryText]?.foreground
        self.ShareButton.tintColor = colorScheme[categoryText]?.foreground
        
        self.LikeButton.isEnabled = false
        self.ShareButton.isEnabled = false
        self.LikeButton.alpha = 0.5
        self.ShareButton.alpha = 0.5
    }
    
    func SetupPickerView() {
        self.innitialCategory = jokeData?.categories.first?.category ?? "unknown"
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelPicker")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.CategoryLabel.inputView = categoryPicker
        self.CategoryLabel.inputAccessoryView = toolBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.CategoryLabel.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            categoryList?[innitialCategory.lowercased()]?.removeFromJoke(jokeData!)
            categoryList?[CategoryLabel.text?.lowercased() ?? "unknown"]?.addToJoke(jokeData!)
            categoryList?[CategoryLabel.text?.lowercased() ?? "unknown"]?.mutableSetValue(forKey: "joke").add(jokeData!)
            try context.save()
        }
        catch let err {
            print("Error editing category : \(err.localizedDescription)")
        }
        print("Category changed")
    }
    
    @objc func donePicker() {
        self.CategoryLabel.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        self.CategoryLabel.text = self.innitialCategory
        self.CategoryLabel.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryList?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.PickerViewLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.CategoryLabel.text = self.PickerViewLabels[row].uppercased()
    }
}
