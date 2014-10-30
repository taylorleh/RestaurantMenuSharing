//
//  SectionedPlaceDetailViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 10/29/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MapKit

class SectionedPlaceDetailViewController: UITableViewController {
    
    // Outlets
    @IBOutlet var firstTableViewCell: UITableViewCell!
    @IBOutlet var restaurantPhotoView: UIImageView!
    @IBOutlet var mainLabelView: UILabel!
    @IBOutlet var detailLabelView: UILabel!
    
    @IBOutlet var restaurantContextControl: UISegmentedControl!
    var PItem: Place!
    var open:String {
        get {
            if self.PItem.open! == true {
                return " Open"
            }
            return "Closed"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainLabelView.text = self.PItem.name
        self.detailLabelView.text = self.PItem.address + " " + open
        
        self.mainLabelView.textColor = UIColor.whiteColor()
        self.detailLabelView.textColor = UIColor.whiteColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.makeBackgroundMapView()

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addOrder" {
            let destination = segue.destinationViewController as AddOrderTableView
            destination.restString = self.PItem.name
            
        }
    }
    
    
    func makeBackgroundMapView() {
        let mapView = MKMapView(frame: self.firstTableViewCell.bounds)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        mapView.region = MKCoordinateRegionMake(self.PItem.coordinate, span)
        
        
        var blurEffect = UIBlurEffect(style: .Dark)
        var visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.frame = self.firstTableViewCell.bounds
        mapView.addSubview(visualEffect)
        firstTableViewCell.backgroundView = mapView
        self.restaurantPhotoView.image = self.PItem.photo
        restaurantPhotoView.layer.cornerRadius = 50.0
        restaurantPhotoView.layer.borderColor = UIColor.whiteColor().CGColor
        restaurantPhotoView.layer.borderWidth = 1.5
        restaurantPhotoView.layer.masksToBounds = true

        mainLabelView.adjustsFontSizeToFitWidth = true
        detailLabelView.adjustsFontSizeToFitWidth = true
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Detail"
        default:
            return "none"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 19.0
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    
}
