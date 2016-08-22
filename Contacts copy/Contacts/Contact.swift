//
//  Contact.swift
//  Contacts
//
//  Created by Ebony Nyenya on 8/17/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit
import CoreData

@objc enum Gender: Int16 {
    case Female //0
    case Male //1
}

class Contact: NSManagedObject {
    
    //Save contacts
    class func saveContactsInDatabase(){
        do {
            try DataManager.sharedManager.managedObjectContext?.save()
            
            //check if it saved
            let path: NSURL = {
                let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
                
                let docDir = appDel!.applicationDocumentsDirectory
                
                return docDir.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
            }()
            
            print("Persistent store path: \(path)")
            
        } catch let error {
            print("Error saving to database: \(error)")
        }
        
    }
    
    //Delete contact
    class func deleteContactFromDatabase(contactID: String){
        let request = NSFetchRequest(entityName: "Contact")
        request.predicate = NSPredicate(format: "id == %@", contactID)
        
        do {
            if let contactToDelete = try DataManager.sharedManager.managedObjectContext?.executeFetchRequest(request).first as? Contact {
                DataManager.sharedManager.managedObjectContext?.deleteObject(contactToDelete)
                
                //save deletion change
                Contact.saveContactsInDatabase()
                
            }
        } catch let error {
            print("Unable to delete contact from database: \(error)")
        }
    }
    
    //Load contacts
    class func loadContactsFromDatabase() -> [Contact]? {
        
        let request = NSFetchRequest(entityName: "Contact")
        request.sortDescriptors = [NSSortDescriptor(
            key: "lastName",
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )]
        
        do {
            if let queryResults = try DataManager.sharedManager.managedObjectContext?.executeFetchRequest(request) as? [Contact] where !queryResults.isEmpty{
                
                DataManager.sharedManager.contacts = queryResults
                
                return queryResults
                
            }
        }catch let error {
            print("Error loading contacts from database: \(error)")
        }
        
        return nil
    }
    
}

