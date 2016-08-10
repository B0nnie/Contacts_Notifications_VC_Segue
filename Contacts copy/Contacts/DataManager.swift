//
//  DataManager.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/30/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import Foundation

class DataManager {
    
    //singleton
    static let sharedManager : DataManager = DataManager()
    
    var contacts = [Contact]()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    //access documents directory and create a file path
    let contactsArchiveURL: NSURL = {
        let documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentDirectory.URLByAppendingPathComponent("contactList")
    }()
    
    
    //MARK: RETRIEVE list of dummy contacts
//    func getContacts() -> [Contact] {
//        
//        //making birthdates of type NSDate for each dummy contact
//        let bday1 = makeDummyBday(day: 3, month: 3, year: 1983)
//        let bday2 = makeDummyBday(day: 10, month: 5, year: 1995)
//        let bday3 = makeDummyBday(day: 5, month: 3, year: 1953)
//        
//        let contact1 = Contact(firstName: "Bob", lastName: "Loblaw", email: "duffmeister@blah.com", phoneNumber: "(404)555-5555", gender: Gender(rawValue: 1)!, birthDate: bday1)
//        
//        contacts.append(contact1)
//        
//        let contact2 = Contact(firstName: "Thierry", lastName: "Henri", email: "esn@blah.com", phoneNumber: "(404)555-5551", gender: Gender(rawValue: 1)!, birthDate: bday2)
//        contacts.append(contact2)
//        
//        let contact3 = Contact(firstName: "Linus", lastName: "Schnagel", email: "lschna@blah.com", phoneNumber: "(404)555-5552", gender: Gender(rawValue: 1)!, birthDate: bday3)
//        contacts.append(contact3)
//        
//        return contacts
//    }
    
//    func makeDummyBday(day day: Int, month: Int, year: Int) -> NSDate {
//        let dateComponents = NSDateComponents()
//        let userCalendar = NSCalendar.currentCalendar()
//        
//        dateComponents.year = year
//        dateComponents.month = month
//        dateComponents.day = day
//        
//        return userCalendar.dateFromComponents(dateComponents)!
//    }
    
    //MARK: UPDATE a contact
    //Return false if the contact didn't exist
    func updateContact(updatedContact : Contact) -> Bool {
        //OLD WAY WITH FOR-IN LOOP:
        //        for contact in contacts {
        //
        //            if contact.contactId == updatedContact.contactId {
        //
        //                //no need to set these properties here as the contact is a reference object whose properties were already changed in memory by DetailsVC saveContactChanges()
        //                //                contact.firstName = updatedContact.firstName
        //                //                contact.lastName = updatedContact.lastName
        //                //                contact.email = updatedContact.email
        //                //                contact.phoneNumber = updatedContact.phoneNumber
        //
        //                let path = getFilePathFromDirectory("contactList")
        //
        //                 writeToDirectory(contacts, filePath: path)
        //
        //                notificationCenter.postNotificationName("CONTACT_CHANGED", object: nil, userInfo: ["contact":updatedContact])
        //
        //                return true
        //            }
        //        }
        //
        //        return false
        
        //NEW WAY WITH FILTER METHOD ON ARRAY:
        let matchingContactFound = contacts.filter{$0.contactId == updatedContact.contactId} //if there's a match, returns an array of one contact with that matching contactId
        
        if !matchingContactFound.isEmpty {
            
            writeToDirectory(contacts, fileNSURL: contactsArchiveURL)
            
            notificationCenter.postNotificationName("CONTACT_CHANGED", object: nil, userInfo: ["contact":updatedContact])
            
            return true
        }
        
        //contact doesn't exist
        return false
    }
    
    //MARK: DELETE a contact
    //Return false if the contact didn't exist
    func deleteContact(contactID : String) -> Bool{
        //OLD WAY USING FOR-IN LOOP:
        //        var contactsArrayIndex = 0
        //
        //        for contact in contacts {
        //
        //            if contact.contactId == contactID {
        //
        //                contacts.removeAtIndex(contactsArrayIndex)
        //
        //                let path = getFilePathFromDirectory("contactList")
        //
        //                 writeToDirectory(contacts, filePath: path)
        //
        //                notificationCenter.postNotificationName("CONTACT_DELETED", object: nil, userInfo: ["contact":contact])
        //                return true
        //            }
        //
        //            contactsArrayIndex += 1
        //
        //        }
        //
        //        return false
        
        //NEW WAY USING FILTER METHOD ON ARRAY:
        let numberOfContactsInArray = contacts.count
        
        //if found, contacts array now contains all contacts EXCEPT the one with the contactID we want to delete
        contacts = contacts.filter{$0.contactId != contactID}
        
        //if contact isn't found (contacts.count stayed the same), return false & exit function
        if numberOfContactsInArray == contacts.count {
            
            return false
        }
        
        //contact found, so re-save changed contacts array to directory and post notification
        writeToDirectory(contacts, fileNSURL: contactsArchiveURL)
        
        notificationCenter.postNotificationName("CONTACT_DELETED", object: nil, userInfo: ["contact":contactID])
        
        return true
        
    }
    
    //MARK: ADD a contact
    func addContact(contact: Contact){
        
        contacts.append(contact)
        
        writeToDirectory(contacts, fileNSURL: contactsArchiveURL)
        
        notificationCenter.postNotificationName("CONTACT_ADDED", object: nil, userInfo: ["contact":contact])
        
    }
    
    //MARK: write file to directory
    private func writeToDirectory(data: AnyObject, fileNSURL: NSURL){
        
        let success = NSKeyedArchiver.archiveRootObject(data, toFile: fileNSURL.path!)//returns a bool
        
        if success {
            print("Saving to directory succeeded")
        } else{
            print("Saving to directory failed")
        }
    }
    
    //MARK: read file containing Contacts from directory
    func readContactsFromDirectory() -> [Contact]?{
        
        let contacts = NSKeyedUnarchiver.unarchiveObjectWithFile(contactsArchiveURL.path!) as? [Contact]
        
        return contacts
    }
    
    //MARK: WEB CALL & PARSING
    //url: http://jsonplaceholder.typicode.com/users
    
    //call web service
    func fetchContacts(){
        
        let url = NSURL(string: "http://jsonplaceholder.typicode.com/users")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, err in
            
            if err != nil {
                print("Got an error: \(err)")
            }
            else {
                
                do {
                    
                    if let results : [[String : AnyObject]] = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]] {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            for jsonDict in results {
                                
                                let newContact = self.parseContact(jsonDict)
                                
                                self.contacts.append(newContact)
                                
                                //print("Contacts: \(self.contacts)")
                            }
                            
                            self.notificationCenter.postNotificationName("GOT_WEB_CONTACTS", object: nil, userInfo: ["contact": ""])
                            
                        })
                    }
                    
                    
                }
                catch {
                    print("Failed to fetch: \(error)")
                }
            }
        }
        
        task.resume()
        
    }
    
    //parse data and use it to set Contact's properties
    func parseContact(jsonDict : [String:AnyObject]) -> Contact {
        
        let newContact = Contact(firstName: "", lastName: "", email: "", phoneNumber: "", gender: nil, birthDate: NSDate(), address: "")
        
        //set Contact's name property
        if let fullName = jsonDict["name"] as? String {
            
            if let names = parseName(fullName) {
                newContact.firstName = names.first
                newContact.lastName = names.last
            }
            
        }
        
        //set Contact's email property
        if let email  = jsonDict["email"] as? String{
            newContact.email = email
        }
        
        //set Contact's phone property
        if let phone = jsonDict["phone"] as? String {
        
        newContact.phoneNumber =  phone
            
        }
        
        //set Contact's address property
        var addressString = String()
    
        if let addressDict = jsonDict["address"] as? [String:AnyObject] {
            
            if let street = addressDict["street"] as? String {addressString += street + ", "}
            if let suite = addressDict["suite"] as? String {addressString += suite + ", "}
            if let city = addressDict["city"] as? String {addressString += city + ", "}
            if let zipcode = addressDict["zipcode"] as? String {addressString += zipcode}
    
            newContact.address = addressString
        
        // print("ADDRESS: \(newContact.address)")
        }
    
        
        //set Contact's contactId property
        if let contactId = jsonDict["id"] as? NSNumber {
            
            newContact.contactId = String(contactId)
        }
        
        return newContact
    }
    
    //helper func used to get first and last name
    func parseName(fullName : String) -> (first: String, last: String)? {
        
        let names = fullName.componentsSeparatedByString(" ")
        //    0          1
        //["Leanne", "Graham"]
        
        if names.count > 1 {
            
            return (first:names[0], last:names[1])
        }
        
        return nil
    }

}