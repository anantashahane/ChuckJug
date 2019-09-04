//
//  JokeCard.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import UIKit

protocol JokeCardDelegate {
    func ClickedLike(on Joke : JokeData)
    func ClickedShare(on Joke : String)
    func ClickedOptions(on Joke : JokeData)
}

class JokeCard: UITableViewCell {

    @IBOutlet weak var CardBackground: UIView!
    @IBOutlet weak var OptionButton: UIButton!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var JokeLabel: UILabel!
    
    var jokeData : JokeData!
    var delegate : JokeCardDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetupCell(for joke: JokeData) {
        let categoryText = joke.categories.first?.category ?? "unknown"
        
        self.selectionStyle = .none
        
        self.jokeData = joke
        self.JokeLabel.text = joke.joke
        self.CategoryLabel.text = categoryText.uppercased()
        
        if jokeData.favourite == true {
            self.LikeButton.setImage(UIImage(named: "Liked"), for: .normal)
        } else {
            self.LikeButton.setImage(UIImage(named: "Like"), for: .normal)
        }
        
        self.contentView.backgroundColor = .clear
        
        self.CardBackground.layer.cornerRadius = 30
        self.CardBackground.backgroundColor = colorScheme[categoryText]?.background
        
        self.CategoryLabel.textColor = colorScheme[categoryText]?.foreground
        self.OptionButton.tintColor = colorScheme[categoryText]?.foreground
        self.JokeLabel.textColor = colorScheme[categoryText]?.foreground
        self.LikeButton.tintColor = colorScheme[categoryText]?.foreground
        self.ShareButton.tintColor = colorScheme[categoryText]?.foreground
        
        self.CardBackground.layer.shadowColor = colorScheme[categoryText]?.background.cgColor
        self.CardBackground.layer.shadowOpacity = 0.5
        self.CardBackground.layer.shadowOffset = .zero
        self.CardBackground.layer.shadowRadius = 10
        self.CardBackground.layer.masksToBounds = false
        
        
    }
    
    
    @IBAction func EditClicked(_ sender: Any) {
        delegate?.ClickedOptions(on: jokeData)
    }
    
    @IBAction func LikeClicked(_ sender: Any) {
        delegate?.ClickedLike(on: jokeData)
    }
    
    @IBAction func ShareClicked(_ sender: Any) {
        delegate?.ClickedShare(on: jokeData.joke ?? "boo")
    }
}
