//
//  SavedOrdersViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/30/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import CoreData


class SavedOrdersViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var savedResults = [NSManagedObject]()
    var selectedItemData:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext as NSManagedObjectContext!
        
        if self.savedResults.count < 1 {
            
            var request = NSFetchRequest(entityName: "Person")
            request.returnsObjectsAsFaults = false
            
            
            var results:[NSManagedObject] = context.executeFetchRequest(request, error: nil) as [NSManagedObject]
            
            for item in results {
                self.savedResults += [item]
            }
            
        }
        

        tableView.reloadData()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("memory warning")
    }
    
    // MARK: - Segue
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "sendItemSegue" {
            var destination = segue.destinationViewController as OptionsViewController
            var path = tableView.indexPathForSelectedRow()!
            var personSelected = self.savedResults[path.section] as Person
            var orderFromPerson = personSelected.orders.allObjects as Array
            var orderToSend: AnyObject = orderFromPerson[path.row] as NSManagedObject

            destination.itemManagedObject = orderToSend as NSManagedObject
        }
    }
    
    
    
    
    // MARK: - Table Delegates
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var personOrders = self.savedResults[section].valueForKey("orders")?.allObjects.count
        return personOrders ?? 1
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.savedResults.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("savedDetail") as UITableViewCell
        var personObject = self.savedResults[indexPath.section] as Person
        var orders = personObject.orders.allObjects as Array
        var order = orders[indexPath.row] as RestaurantItem
        println(order)
        
        cell.textLabel.text = order.foodItem
        cell.detailTextLabel?.text = order.restaurantName
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var pInIndex = self.savedResults[section] as Person
        var name = pInIndex.name
        return name ?? "unknown name"
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
