//
//  MPCHandler.swift
//  RestaurantWithFriends
//
//  Created by Taylor Lehman on 9/30/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class MPCHandler: NSObject, MCSessionDelegate {
    
    let kReceivingData = "isReceivingData"
    
    // identifier of this device
    var peerID:MCPeerID!
    
    // manages a multipeer session
    var session:MCSession!
    
    // specialized viewontroller that dispays nearby devices
    var browser:MCBrowserViewController?
    
    // advertises device and handles incoming connections
    var advertiser:MCAdvertiserAssistant!
    
    
    // METHODS
    
    func setupPeerWithDisplayName(displayName:String) -> Void {
        self.peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession() -> Void  {
        self.session = MCSession(peer: self.peerID)
        self.session.delegate = self
    }
    
    func setupBrowser() -> Void {
        self.browser = MCBrowserViewController(serviceType: "restaurant-item", session: self.session)
    }
    
    func advertiseSelf(advertise:Bool) -> Void {
        if advertise {
            self.advertiser = MCAdvertiserAssistant(serviceType: "restaurant-item", discoveryInfo: nil, session: self.session)
            self.advertiser.start()
        } else {
            self.advertiser.stop()
            self.advertiser = nil
        }
    }
    
    
    // MARK: MC Session Protocol Delegates
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        var _state:String!
        switch state {
        case .Connected:
            _state = "Connected"
            println("Connected")
            var userInfo = ["state":_state] as Dictionary<String,String>
            NSNotificationCenter.defaultCenter().postNotificationName(kReceivingData, object: nil,userInfo:userInfo)
        case .Connecting:
            _state = "Connecting"
            println("Connecting")
        case .NotConnected:
            _state = "NotConnected"
            println("Not Connected")
            
        }
        
        
        
    }
    
    
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var userInfo = ["state":"finished"] as Dictionary<String,String>
        
        NSNotificationCenter.defaultCenter().postNotificationName(kReceivingData, object: nil,userInfo:userInfo)
        
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        var context = appDel.managedObjectContext as NSManagedObjectContext!
        
        var request = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context!)
        request.entity = entity
        
        // extract the incoming data
        var newData:AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        // create predicated
        if let arr = newData as? Dictionary<String,String> {

            var incomingDeviceName = peerID.displayName
            var predicate = NSPredicate(format: "name == %@", incomingDeviceName)
            
            request.predicate = predicate
            var personExistsInCurrentDevice:[NSManagedObject] = context.executeFetchRequest(request, error: nil) as [NSManagedObject]
            
            if personExistsInCurrentDevice.count > 0 {
                println("person exists, adding new order")
                var personRef = personExistsInCurrentDevice[0] as Person
                var currentOrders = personRef.orders
                var orderEntity = NSEntityDescription.entityForName("RestaurantItem", inManagedObjectContext: context)
                var newOrder = RestaurantItem(entity: orderEntity!, insertIntoManagedObjectContext: context)
                newOrder.foodItem = arr["item"] ?? "none"
                newOrder.restaurantName = arr["name"] ?? "none"
                newOrder.itemDetails = arr["detail"] ?? "none"
                newOrder.person = personRef
                
                personRef.orders.setByAddingObject(newOrder)
                
                context.save(nil)
                
                
            } else {
                var orderEntity = NSEntityDescription.entityForName("RestaurantItem", inManagedObjectContext: context)
                
                var newPerson = Person(entity: entity!, insertIntoManagedObjectContext: context)
                newPerson.name = incomingDeviceName
                
                
                var newOrder = RestaurantItem(entity: orderEntity!, insertIntoManagedObjectContext: context)
                newOrder.foodItem = arr["item"] ?? "none"
                newOrder.restaurantName = arr["name"] ?? "none"
                newOrder.itemDetails = arr["detail"] ?? "none"
                newOrder.person = newPerson
                
                newPerson.orders = NSSet(object: newOrder)
                println("saving new item to core data \(newPerson)")
                context.save(nil)
                
            }
            
            
        }

        
        
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("is receiving resource")
        
    }
    
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
        println("Started receiving from peer")
        
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    
}
