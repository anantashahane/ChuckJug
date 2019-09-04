//
//  JokeStructure.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import Foundation

struct Joke : Codable {
    let category : [String]?
    let icon_url : URL
    let id : String
    let url : URL
    let value : String
}
