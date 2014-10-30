//
//  PlacesMapViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/1/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MapKit


class PlacesMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var map:MKMapView? = MKMapView()
    
    var mapItemsList:[Place]!
    var annotation:PlaceAnnotation?
    let cordSpan = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.mapItemsList.count > 1 {
            
            for item in self.mapItemsList {
                annotation = PlaceAnnotation(coordinate: item.coordinate)
                annotation?.title = item.name
                self.map?.addAnnotation(annotation)
            }
            
            self.map?.region = MKCoordinateRegion(center: self.mapItemsList[0].coordinate, span: self.cordSpan)
            
        }
        
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView:MKPinAnnotationView?
        
        if annotation.isKindOfClass(PlaceAnnotation) {
            
            annotationView = self.map?.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView?.canShowCallout = true
                annotationView?.animatesDrop = true
            }
            
        }
        return annotationView
        
    }
    
    
    
    
}
