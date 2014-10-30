//
//  AddOrderTableView.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/29/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import CoreData

class AddOrderTableView: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var restString:String!
    
    @IBOutlet var restName: UILabel? = UILabel()
    @IBOutlet var menuItem:UITextField? = UITextField()
    @IBOutlet var menuItemDesciption:UITextField? = UITextField()
    
    // table cells

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.restName?.text = self.restString
        
    }
    
    
    
    @IBAction func saveBtn_Click(sender:UIBarButtonItem) {
        if self.menuItem == nil || self.menuItemDesciption == nil {
            println("menu or menuitems description are nil..exiting")
            return
        }
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext as NSManagedObjectContext!
        
        var request = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)
        request.entity = entity
        var predicate = NSPredicate(format: "name == %@", UIDevice.currentDevice().name)
        request.predicate = predicate
        
        
        var results:[NSManagedObject] = context.executeFetchRequest(request, error: nil) as [NSManagedObject]
        var orderToAdd:RestaurantItem!
        
        if results.count == 1 {
            println("one identity found.. adding order to persons orders")
            var personRef = results[0] as Person
            var restaurantEntity = NSEntityDescription.entityForName("RestaurantItem", inManagedObjectContext: context)
            orderToAdd = RestaurantItem(entity: restaurantEntity!, insertIntoManagedObjectContext: context)
            orderToAdd.foodItem = self.menuItem?.text ?? "none"
            orderToAdd.itemDetails = self.menuItemDesciption?.text ?? "none"
            orderToAdd.restaurantName = self.restName?.text ?? "none"
            orderToAdd.person = personRef
            personRef.orders.setByAddingObject(orderToAdd)
            context.save(nil)
            
        } else {
            println("some error")
            var newPerson = Person(entity: entity!, insertIntoManagedObjectContext: context)
            newPerson.name = UIDevice.currentDevice().name
            var restaurantEntity = NSEntityDescription.entityForName("RestaurantItem", inManagedObjectContext: context)
            orderToAdd = RestaurantItem(entity: restaurantEntity!, insertIntoManagedObjectContext: context)
            orderToAdd.foodItem = self.menuItem?.text ?? "none"
            orderToAdd.itemDetails = self.menuItemDesciption?.text ?? "none"
            orderToAdd.restaurantName = self.restName?.text ?? "none"
            orderToAdd.person = newPerson
            newPerson.orders = NSSet(object: orderToAdd)
            println("the new person object is \(newPerson)")
            context.save(nil)
            
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.toolbarHidden = true
        
    }
    
    
    @IBAction func cancelBtn_Click(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("received memory warning")
    }
    
    
    
}
