//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Bettina on 3/17/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
