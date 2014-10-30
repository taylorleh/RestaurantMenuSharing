//
//  RestaurantItem.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/7/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import Foundation
import CoreData

class RestaurantItem: NSManagedObject {

    @NSManaged var foodItem: String
    @NSManaged var itemDetails: String
    @NSManaged var restaurantName: String
    @NSManaged var person: Person

}
