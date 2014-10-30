//
//  PlaceDetailViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/25/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//




// **** REPLACE WITH SectionedViewController *******


import UIKit
import MapKit

class PlaceDetailViewController: UITableViewController {
    
    var placeDetailItem:Place!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.toolbarHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad(
        )
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("memory warning")
    }
    
    
    
    @IBAction func showAVC(sender:UIBarButtonItem) -> Void {
        var imageToShare:UIImage?
        var avc:UIActivityViewController?
        
        if let pto = self.placeDetailItem.photo {
            imageToShare = pto
            avc = UIActivityViewController(activityItems: [pto], applicationActivities: nil)
            self.navigationController?.presentViewController(avc!, animated: true, completion: nil)
            
        } else {
            println("image wasn't instantiated... aborting activity view contorller")
        }
        
    }
    
    
    func makMapFromLocation() -> UIImage {
        var img = UIImage(named: "missing")!
        return img
        
    }
    
    
    
    
    // MARK: - Table Delegates
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        var placePhoto:UIImage = self.placeDetailItem.photo ?? makMapFromLocation()
        
        
        var imgView = UIImageView(frame: CGRectMake((tableView.frame.width / 2) - (placePhoto.size.width / 2), 0, 150, 150))
        imgView.image = placePhoto
        imgView.layer.borderColor = UIColor.whiteColor().CGColor
        imgView.layer.cornerRadius = 75.0
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 4.0
        imgView.layer.borderColor = UIColor.whiteColor().CGColor
        
        

        
        let backGrondMap = MKMapView(frame: self.tableView.bounds)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        backGrondMap.region = MKCoordinateRegion(center: self.placeDetailItem.coordinate, span: mapSpan)
        cell.backgroundView = backGrondMap
        

        
        var blurEffect = UIBlurEffect(style: .Dark)
        var visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.frame = CGRectMake(0, 0, tableView.frame.width, self.placeDetailItem.photo!.size.width + 60)
        cell.contentView.addSubview(visualEffect)
        
        cell.contentView.addSubview(imgView)
        
        
        var defualtRect = CGRectMake(0, 150, tableView.frame.width, 20)
        
        var mainLabel = UILabel(frame: defualtRect)
        mainLabel.text = placeDetailItem.name
        mainLabel.font = UIFont(name: "Copperplate", size: 20.0)
        mainLabel.textAlignment = NSTextAlignment.Center
        mainLabel.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(mainLabel)
        
        // increment default rect
        defualtRect.origin.y += 20
        
        var address = UILabel(frame: defualtRect)
        address.text = placeDetailItem.address
        address.font = UIFont(name: "Copperplate", size: 14.0)
        address.textAlignment = NSTextAlignment.Center
        address.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(address)
        
        defualtRect.origin.y += 20
        
        var openLabel = UILabel(frame: defualtRect)
        if placeDetailItem.open == true {
            openLabel.text = "open"
            openLabel.textColor = UIColor.greenColor()
        } else {
            openLabel.text = "closed"
            openLabel.textColor = UIColor.redColor()
        }
        openLabel.font = UIFont(name: "Copperplate", size: 12.0)
        openLabel.textAlignment = NSTextAlignment.Center
        cell.contentView.addSubview(openLabel)
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addSegue" {
            var destination = segue.destinationViewController as AddOrderTableView
            destination.restString = self.placeDetailItem.name
            
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let photo = self.placeDetailItem.photo {
            return photo.size.width + 60
            
            
        } else {
            return 120
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}
