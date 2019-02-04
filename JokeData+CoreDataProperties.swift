//
//  JokeData+CoreDataProperties.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/02/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//
//

import Foundation
import CoreData


extension JokeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JokeData> {
        return NSFetchRequest<JokeData>(entityName: "JokeData")
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var favoured: NSDate?
    @NSManaged public var favourite: Bool
    @NSManaged public var joke: String?
    @NSManaged public var jokeid: String?
    @NSManaged public var categories: Set<Categories>

}

// MARK: Generated accessors for categories
extension JokeData {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Categories)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Categories)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
