//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Bettina on 3/17/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() { //anytime this item is inserted into NSManagedObjectContext or when it's created from the entity this function will be called. When it's inserted into object context, go ahead and assign current date to the attribute createdAt. Essentially creating time stamp for your items.
        super.awakeFromInsert()
        
        self.createdAt = NSDate()
    }
}
