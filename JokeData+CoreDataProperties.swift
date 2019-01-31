//
//  JokeData+CoreDataProperties.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 31/01/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//
//

import Foundation
import CoreData


extension JokeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JokeData> {
        return NSFetchRequest<JokeData>(entityName: "JokeData")
    }

    @NSManaged public var category: NSObject?
    @NSManaged public var favourite: Bool
    @NSManaged public var joke: String?
    @NSManaged public var jokeid: String?
    @NSManaged public var added: NSDate?
    @NSManaged public var favoured: NSDate?

}
