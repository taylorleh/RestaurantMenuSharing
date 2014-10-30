//
//  OptionsViewController.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/30/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData


class OptionsViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    var appDel:AppDelegate!
    var itemManagedObject:NSManagedObject!
    
    @IBOutlet var connectedPeersView:UITextView? = UITextView()
    @IBOutlet var foodItemLabel:UILabel? = UILabel()
    @IBOutlet var foodDescript:UILabel? = UILabel()
    
    
    
    //MARK: - View Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDel = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.foodItemLabel?.text = self.itemManagedObject.valueForKey("foodItem") as? String
        
        self.foodDescript?.text = self.itemManagedObject.valueForKey("itemDetails") as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("memory warning")
    }
    
    
    
    
    //MARK: - Actions
    
    @IBAction func findNearbyDevices(sender:AnyObject) {
        if self.appDel.mpcHandler.session != nil {
            self.appDel.mpcHandler.setupBrowser()
            self.appDel.mpcHandler.browser?.delegate = self
            
            presentViewController(self.appDel.mpcHandler.browser!, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func sendData(sender:AnyObject) -> Void {
        
        if self.appDel.mpcHandler.session.connectedPeers.count < 1 {
            println("no connected peers")
            return
        }
    
        var personOrder = self.itemManagedObject as RestaurantItem
        var customObjectToSend = ["name":personOrder.restaurantName,"item":personOrder.foodItem,"detail":personOrder.itemDetails]
        var archivedObjectToSend = NSKeyedArchiver.archivedDataWithRootObject(customObjectToSend)
        
        self.appDel.mpcHandler.session.sendData(archivedObjectToSend, toPeers: self.appDel.mpcHandler.session.connectedPeers, withMode: .Reliable, error: nil)

        
    }
    
    
    
    
    // MARK: - Browser ViewController Delegates
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        println("browser vc did finish")
        
        self.connectedPeersView?.text = self.appDel.mpcHandler.session.connectedPeers[0].displayName
        println(self.connectedPeersView?.text)
        self.connectedPeersView?.reloadInputViews()
        self.appDel.mpcHandler.browser?.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        self.appDel.mpcHandler.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    

    
    
}
