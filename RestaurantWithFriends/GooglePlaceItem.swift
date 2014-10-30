//
//  GooglePlaceItem.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/25/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MapKit


class GooglePlaceItem {
    
    let coordinate:CLLocationCoordinate2D
    let name:String
    let address:String
    
    var photoID:String?
    var restaurantImage:UIImage?
    var restaurantImageAsData:NSData? {
        didSet {
            self.restaurantImage = UIImage(data: self.restaurantImageAsData!)
        }
    }

    var price:Int?
    var rating:Int?
    var open:Bool?
    
    init (location:CLLocationCoordinate2D, name:String, address:String) {
        self.coordinate = location
        self.name = name
        self.address = address
    }
}