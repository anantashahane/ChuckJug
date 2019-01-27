//
//  JokeCell.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 12/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit
import CoreData

protocol JokeCellDelegate {
    func didTapShare(joke: String)
    func didTapFavourite(Joke: JokeData)
}

class JokeCell: UICollectionViewCell {
    var persistentData : JokeData!
    
    var delegate : JokeCellDelegate?
    
    @IBOutlet weak var FavButton: UIButton!
    @IBOutlet weak var CategoryText: UILabel!
    @IBOutlet weak var JokeText: UILabel!
    
    public func Initiate(_ joke: JokeData) {
        self.persistentData = joke
        if let category = joke.category as? [String] {
            self.CategoryText.text = category.first
        }
        else {
            self.CategoryText.text = "Unknown"
        }
        self.JokeText.text = joke.joke ?? ""
        if self.persistentData.favourite {
            self.FavButton.tintColor = .red
        }
        else {
            self.FavButton.tintColor = .black
        }
    }
    
  
    
    @IBAction func FavouriteClicked(_ sender: Any) {
        persistentData.favourite.toggle()
        if persistentData.favourite {
            self.FavButton.tintColor = .red
        }
        else {
            self.FavButton.tintColor = .black
        }
       delegate?.didTapFavourite(Joke: persistentData)
    }
    
    @IBAction func ShareClicked(_ sender: Any) {
        delegate?.didTapShare(joke: self.persistentData.joke!)
        
    }
    
}
