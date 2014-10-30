//
//  Person.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/7/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var orders: NSSet

}
