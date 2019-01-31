//
//  CategorisedCell.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit

protocol CategorisedCellDelegate {
    func didClickedFavourite(for Joke: JokeData)
    func didClickedAction(for Joke: String)
}

class CategorisedCell: UITableViewCell {

    @IBOutlet weak var BackGround: UIImageView!
    @IBOutlet weak var Favorite: UIBarButtonItem!
    @IBOutlet weak var JokeLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    var delegate : CategorisedCellDelegate?
    let BackGroundImage = ["explicit" : UIImage.init(named: "explicit"),
                           "dev" : UIImage.init(named: "dev"),
                           "movie": UIImage.init(named: "movie"),
                           "food": UIImage.init(named: "food"),
                           "celebrity": UIImage.init(named: "celebrity"),
                           "science" : UIImage.init(named: "science"),
                           "sport" : UIImage.init(named: "sport"),
                           "political" : UIImage.init(named: "political"),
                           "religion" : UIImage.init(named: "religion"),
                           "animal" : UIImage.init(named: "aminal"),
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
        let category = self.Jokedata.category as? [String]
        let bmi = BackGroundImage[category?.first ?? "unknown"]!
        self.BackGround.image = bmi
        self.CategoryLabel.text = category?.first ?? "unknown"
        self.JokeLabel.text = self.Jokedata.joke
        if Jokedata.favourite {
            self.Favorite.tintColor = .red
        }
        else {
            self.Favorite.tintColor = .black
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ShareClicked(_ sender: Any) {
        delegate?.didClickedAction(for: Jokedata.joke!)
    }
    @IBAction func FavouriteClicked(_ sender: Any) {
        self.Jokedata.favourite.toggle()
        if Jokedata.favourite {
            self.Favorite.tintColor = .red
            self.Jokedata.favoured = Date.init(timeIntervalSinceNow: 0) as NSDate
        }
        else {
            self.Favorite.tintColor = .black
            self.Jokedata.favoured = nil
        }
        delegate?.didClickedFavourite(for: Jokedata)
    }
}
