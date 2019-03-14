//
//  RandomCell.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit

protocol JokeCellDelegate {
    func didClickedFavourite(for Joke: JokeData)
    func didClickedAction(for Joke: String)
}

class RandomCell: UITableViewCell {

    @IBOutlet weak var Favourite: UIBarButtonItem!
    @IBOutlet weak var JokeLabel: UILabel!
    @IBOutlet weak var BackGround: UIImageView!
    @IBOutlet weak var CategoryLabel: UILabel!
    
    var delegate : JokeCellDelegate?
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
    var Jokedata : JokeData!
    
    public func SetupCell(for Joke: JokeData) {
        self.Jokedata = Joke
        let category = self.Jokedata.categories
        var CategoryText = ""
        for jokeCategory in Jokedata.categories {
            if CategoryText == "" {
                CategoryText = jokeCategory.category!
            } else {
                CategoryText.append(contentsOf: ", \(jokeCategory.category!)")
            }
        }
        self.CategoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        self.CategoryLabel.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        let bmi = BackGroundImage[category.first?.category ?? "unknown"]!
        self.BackGround.image = bmi
        self.CategoryLabel.text = CategoryText
        
        self.JokeLabel.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        var fontsize : CGFloat = 16
        while self.JokeLabel.heightAnchor.constraint(lessThanOrEqualToConstant: self.BackGround.heightAnchor) {
            fontsize = fontsize + 2
            self.JokeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontsize)
        }
        
        if Jokedata.favourite {
            self.Favourite.tintColor = .red
        }
        else {
            self.Favourite.tintColor = .black
        }
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    @IBAction func FavouriteClicked(_ sender: Any) {
        self.Jokedata.favourite.toggle()
        if Jokedata.favourite {
            self.Favourite.tintColor = .red
            self.Jokedata.favoured = Date.init(timeIntervalSinceNow: 0) as NSDate
        }
        else {
            self.Favourite.tintColor = .black
            self.Jokedata.favoured = nil
        }
        delegate?.didClickedFavourite(for: Jokedata)
    }
    
    @IBAction func ActionClicked(_ sender: Any) {
        delegate?.didClickedAction(for: Jokedata.joke!)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
