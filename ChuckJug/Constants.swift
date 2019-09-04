//
//  Constants.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import Foundation
import UIKit

struct ColorBundle {
    let background : UIColor!
    let foreground : UIColor!
}

let animalColorBundle = ColorBundle(background: UIColor(red: 46/255.0, green: 35/255.0, blue: 0/255.0, alpha: 1), foreground: UIColor(red: 219/255.0, green: 149/255.0, blue: 1/255.0, alpha: 1))

let careerColorBundle = ColorBundle(background: UIColor(red: 104/255.0, green: 130/255.0, blue: 158/255.0, alpha: 1), foreground: UIColor(red: 188/255.0, green: 186/255.0, blue: 190/255.0, alpha: 1))

let celebrityColorBundle = ColorBundle(background: UIColor(red: 217/255.0, green: 180/255.0, blue: 74/255.0, alpha: 1), foreground: UIColor(red: 244/255.0, green: 70/255.0, blue: 87/255.0, alpha: 1))

let devColorBundle = ColorBundle(background: .black, foreground: UIColor(red: 52/255.0, green: 103/255.0, blue: 92/255.0, alpha: 1))

let explicitColorBundle = ColorBundle(background: UIColor(red: 178/255.0, green: 71/255.0, blue: 62/255.0, alpha: 1), foreground: UIColor(red: 234/255.0, green: 179/255.0, blue: 100/255.0, alpha: 1))

let fashionColorBundle = ColorBundle(background: UIColor(red: 208/255.0, green: 150/255.0, blue: 131/255.0, alpha: 1), foreground: UIColor(red: 54/255.0, green: 50/255.0, blue: 55/255.0, alpha: 1))

let foodColorBundle = ColorBundle(background: UIColor(red: 179/255.0, green: 136/255.0, blue: 103/255.0, alpha: 1), foreground: UIColor(red: 98/255.0, green: 109/255.0, blue: 113/255.0, alpha: 1))

let historyColorBundle = ColorBundle(background: UIColor(red: 125/255.0, green: 68/255.0, blue: 39/255.0, alpha: 1), foreground: UIColor(red: 249/255.0, green: 220/255.0, blue: 36/255.0, alpha: 1))

let moneyColorBundle = ColorBundle(background: UIColor(red: 46/255.0, green: 70/255.0, blue: 0/255.0, alpha: 1), foreground: UIColor(red: 162/255.0, green: 197/255.0, blue: 35/255.0, alpha: 1))

let movieColorBundle = ColorBundle(background: UIColor(red: 46/255.0, green: 35/255.0, blue: 0/255.0, alpha: 1), foreground: UIColor(red: 219/255.0, green: 149/255.0, blue: 1/255.0, alpha: 1))

let musicColorBundle = ColorBundle(background: UIColor(red: 7/255.0, green: 87/255.0, blue: 91/255.0, alpha: 1), foreground: UIColor(red: 164/255.0, green: 56/255.0, blue: 32/255.0, alpha: 1))

let politicalColorBundle = ColorBundle(background: UIColor(red: 0/255.0, green: 59/255.0, blue: 70/255.0, alpha: 1), foreground: UIColor(red: 186/255.0, green: 85/255.0, blue: 54/255.0, alpha: 1))

let religionColorBundle = ColorBundle(background: UIColor(red: 222/255.0, green: 122/255.0, blue: 34/255.0, alpha: 1), foreground: UIColor(red: 32/255.0, green: 148/255.0, blue: 139/255.0, alpha: 1))

let scienceColorBundle = ColorBundle(background: UIColor(red: 251/255.0, green: 205/255.0, blue: 75/255.0, alpha: 1), foreground: UIColor(red: 40/255.0, green: 38/255.0, blue: 35/255.0, alpha: 1))

let sportColorBundle = ColorBundle(background: UIColor(red: 80/255.0, green: 109/255.0, blue: 47/255.0, alpha: 1), foreground: UIColor(red: 243/255.0, green: 235/255.0, blue: 221/255.0, alpha: 1))

let travelColorBundle = ColorBundle(background: UIColor(red: 244/255.0, green: 58/255.0, blue: 211/255.0, alpha: 1), foreground: UIColor(red: 45/255.0, green: 140/255.0, blue: 114/255.0, alpha: 1))

let unknownColorBundle = ColorBundle(background: .black, foreground: .white)

let colorScheme = ["explicit" : explicitColorBundle,
                   "dev" : devColorBundle,
                   "movie": movieColorBundle,
                   "food": foodColorBundle,
                   "celebrity": celebrityColorBundle,
                   "science" : scienceColorBundle,
                   "sport" : sportColorBundle,
                   "political" : politicalColorBundle,
                   "religion" : religionColorBundle,
                   "animal" : animalColorBundle,
                   "history" : historyColorBundle,
                   "music" : musicColorBundle,
                   "travel" : travelColorBundle,
                   "career" : careerColorBundle,
                   "money" : moneyColorBundle,
                   "fashion" : fashionColorBundle,
                   "unknown" : unknownColorBundle]
