//
//  Place.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/28/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import Foundation
import MapKit

class Place {
    let coordinate:CLLocationCoordinate2D
    let name:String
    let address:String
    
    var open:Bool?
    
    private var gPhotoApi = "https://maps.googleapis.com/maps/api/place/photo?key=***KEY***&maxwidth=150&"
    var photo:UIImage?
    var photoID:String? {
        didSet {
            self.downloadPlacePhoto(photoID!)
        }
    }
    

    
    init (loc:CLLocationCoordinate2D, name:String, address:String) {
        self.coordinate = loc
        self.name = name
        self.address = address
    }
    
    func downloadPlacePhoto(key:String) {
        let url = NSURL(string: self.gPhotoApi + "photoreference=" + key)
        var task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
            (data,response,error) in
            if error == nil {
                self.photo = UIImage(data: data)
            }

        })
        task.resume()
    }
    
    
}


