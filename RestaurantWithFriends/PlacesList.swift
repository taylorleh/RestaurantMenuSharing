//
//  Places.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/23/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import CoreLocation


internal class PlacesList {
    
    private var list: [Place]!
    
    init() {
        self.list = [Place]()
    }
    
    func addPlaceToList(place:Place) {
        self.list.append(place)
    }
    
    func count() ->Int {
        return self.list.count
    }
    
    func getPlace(atIndex:Int) -> Place {
        return self.list[atIndex]
    }
    
    func removeAll() {
        self.list.removeAll(keepCapacity: false)
    }
    
    func getAll() ->[Place] {
        return self.list
    }
    
    
}
