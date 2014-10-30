//
//  PlaceAnnotation.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/1/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation:NSObject, MKAnnotation {
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var url:NSURL?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
