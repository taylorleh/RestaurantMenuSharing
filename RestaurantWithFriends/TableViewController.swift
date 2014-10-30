//
//  ViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/25/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MultipeerConnectivity

class TableViewController:UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // properties
    var userLocation:CLLocation?
    var placesIter = PlaceIterator()
    let kReceivingData = "isReceivingData"
    var appDel:AppDelegate!
    let locationManager = CLLocationManager()
    
    var activityIndicator:UIActivityIndicatorView?
    
    // Google Places API
    var gPlacesRoot = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=150&types=restaurant&key=***KEY***"
    
    // Outlet and Action
    @IBOutlet var concreteSearchBar:UISearchBar!
    @IBOutlet var viewAll_btn: UIBarButtonItem!
    
    @IBAction func viewAll_btn_click (sender:UIBarButtonItem) {
        //TODO
        
    }
    
    
    
    //MARK: - VIEW DELEGATES
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isReceivingDataFromPeer:", name: kReceivingData, object: nil)
        
        self.locationManager.delegate = self
        self.concreteSearchBar.delegate = self
        
        self.appDel = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.setupMPC()
        
        self.navigationController?.toolbarHidden = false
        self.viewAll_btn.enabled = false
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.userLocation == nil {
            switch CLLocationManager.authorizationStatus() {
            case .Authorized:
                locationManager.startUpdatingLocation()
            case .AuthorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            default:
                println("default case block reached")
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "placeDetail" {
            var destination = segue.destinationViewController as SectionedPlaceDetailViewController
            var selectedRow = tableView.indexPathForSelectedRow()!
            destination.PItem = self.placesIter.getPlace(self.tableView.indexPathForSelectedRow()!.row)
        }
        
        if segue.identifier == "viewAllSegue" {
            var destination = segue.destinationViewController as PlacesMapViewController
            destination.mapItemsList = self.placesIter.getAll()
        }
        
        // **** DELETE Identified after testing new ViewController *****
        
    }
    
    
    deinit {
        // unregister self from all notifications to ensure our listener is deallocated
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }
    
    // Multipeer Helper
    func setupMPC() {
        self.appDel.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
        self.appDel.mpcHandler.setupSession()
        self.appDel.mpcHandler.advertiseSelf(true)
        
    }
    
    func isReceivingDataFromPeer(notification:NSNotification!) {
        println(notification)
        
        var ui = notification.userInfo as Dictionary<String,String>?
        if ui?["state"] == "Connected" {
            println("YEP")
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.popToRootViewControllerAnimated(true)
                self.handleActivityIndicator()
                return
            })
        } else if ui?["state"] == "finished" {
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator?.stopAnimating()
                self.appDel.mpcHandler.session.disconnect()
                
            })
            NSNotificationCenter.defaultCenter().removeObserver(self, name: kReceivingData, object: nil)
        }

    }
    
    func handleActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator?.frame = self.view.frame
        activityIndicator?.center = self.view.center
        activityIndicator?.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator!)
        self.view.alpha = 0.8
        activityIndicator?.startAnimating()
    }
    
    // MARK: - JSON Methods
    
    func parseJSON(json:AnyObject) {
        if let JSONObject = json["results"] as? NSArray {
            self.placesIter.allocateJSONObject(JSONObject)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
        }
        
    }
    
    
    
    // MARK: - SEARCH BAR DELEGATES
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        return self.performSearch(searchBar.text)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text.isEmpty {
            self.placesIter.removeAll()
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
        
    }
    
    
    // MARK: - Search Bar / Location Helpers
    func performSearch(searchString:String) {
        if let location = userLocation?.coordinate  {
            var url = NSURL(string: self.gPlacesRoot + "&location=\(location.latitude),\(location.longitude)&keyword=\(searchString)")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
                (data,response,error) in
                if error == nil {
                    self.parseJSON(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)!)
                    
                }
            })
            task.resume()
        } else {
            println("User location is nil, cannot perform search")
        }
        
    }
    
    
    
    // MARK: - Table View Delegates
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placesIter.count()
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell
        
        cell.textLabel.text = self.placesIter.getPlace(indexPath.row).name
        cell.detailTextLabel?.text = self.placesIter.getPlace(indexPath.row).address

        return cell
    }
    
    // MARK: - Core Location Delegates
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        if let location = locations[0] as? CLLocation {
            self.userLocation = location
            println(location)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("status changed")
        
    }

}

