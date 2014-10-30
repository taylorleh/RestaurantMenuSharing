//
//  SGooglePlaceItem.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/23/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MapKit


class PlaceIterator:PlacesList {
    
    
    override init() {
        super.init()
    }
    
    
    func allocateJSONObject(json:NSArray) {
        for placeResults in json {
            if let placeAttributes = placeResults as? NSDictionary {
                
                var cord:CLLocationCoordinate2D?
                var lat:CLLocationDegrees?
                var lng:CLLocationDegrees?
                
                
                for (key,value) in placeAttributes["geometry"]?["location"] as NSDictionary {
                    if key as NSString == "lat" {
                        lat = value as? CLLocationDegrees
                    } else {
                        lng = value as? CLLocationDegrees
                    }
                }
                
                cord = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                var _p = Place(loc: cord!, name: placeAttributes["name"] as String!, address: placeAttributes["vicinity"] as String!)
                _p.photoID = placeAttributes["photos"]?[0]["photo_reference"] as String!
                _p.open = placeAttributes["opening_hours"]?["open_now"] as? Bool

                self.addPlaceToList(_p)
                
            }
        }

    }
    
    
    
}
