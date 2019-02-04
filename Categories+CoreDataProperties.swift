//
//  Categories+CoreDataProperties.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/02/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var category: String?
    @NSManaged public var joke: Set<JokeData>

}

// MARK: Generated accessors for joke
extension Categories {

    @objc(addJokeObject:)
    @NSManaged public func addToJoke(_ value: JokeData)

    @objc(removeJokeObject:)
    @NSManaged public func removeFromJoke(_ value: JokeData)

    @objc(addJoke:)
    @NSManaged public func addToJoke(_ values: NSSet)

    @objc(removeJoke:)
    @NSManaged public func removeFromJoke(_ values: NSSet)

}
