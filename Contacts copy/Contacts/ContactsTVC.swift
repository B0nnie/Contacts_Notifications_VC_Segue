//
//  ViewController.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/18/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit
import CoreData

class ContactsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadContactListFromDataManager()
        addObservers()
        
    }
    
    private func loadContactListFromDataManager(){
        //if there are contacts saved in CoreData already, then load those; otherwise fetchContacts from web
        if Contact.loadContactsFromDatabase() != nil {
            //load contacts from database
        } else {
            //get contacts from web and then save them in CoreData
            DataManager.sharedManager.fetchContacts()
            
        }
        
    }
    
    private func addObservers(){
        DataManager.sharedManager.notificationCenter.addObserverForName("CONTACT_CHANGED", object: nil, queue: nil, usingBlock: { [weak self] _ in self?.tableView.reloadData() })
        
        DataManager.sharedManager.notificationCenter.addObserverForName("CONTACT_DELETED", object: nil, queue: nil, usingBlock: { [weak self] _ in self?.tableView.reloadData() })
        
        DataManager.sharedManager.notificationCenter.addObserverForName("CONTACT_ADDED", object: nil, queue: nil, usingBlock: { [weak self] _ in self?.tableView.reloadData() })
        
        DataManager.sharedManager.notificationCenter.addObserverForName("GOT_WEB_CONTACTS", object: nil, queue: nil, usingBlock: { [weak self] _ in self?.tableView.reloadData() })
    }
    
    //MARK: - TableView Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("toDetailsVC", sender: indexPath)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.sharedManager.contacts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if let fName = DataManager.sharedManager.contacts[indexPath.row].firstName, let lName = DataManager.sharedManager.contacts[indexPath.row].lastName {
            cell?.textLabel!.text = "\(fName)" + " " + "\(lName)"
        }
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetailsVC" {
            
            let detailsVC = segue.destinationViewController as? DetailsVC
            
            if let path = sender as? NSIndexPath {
                
                detailsVC!.selectedContact = DataManager.sharedManager.contacts[path.row]
                
            }
        }
    }
    
    
    //unregister observers
    deinit{
        DataManager.sharedManager.notificationCenter.removeObserver(self, name: "CONTACT_CHANGED", object: nil)
        DataManager.sharedManager.notificationCenter.removeObserver(self, name: "CONTACT_DELETED", object: nil)
        DataManager.sharedManager.notificationCenter.removeObserver(self, name: "CONTACT_ADDED", object: nil)
        DataManager.sharedManager.notificationCenter.removeObserver(self, name: "GOT_WEB_CONTACTS", object: nil)
    }
    
    
    //MARK: Enter new contact modal alert controller
    //
    //    @IBAction func addContactPressed(){
    //
    //        var firstName = ""
    //        var lastName = ""
    //        var phoneNumber = ""
    //        var email = ""
    //
    //        let alertController = UIAlertController(title: "New Contact", message: "", preferredStyle: .Alert)
    //
    //        let addAction = UIAlertAction(title: "Add New Contact", style: .Default) { _ in
    //
    //            firstName = (alertController.textFields![0] as UITextField).text!
    //            lastName = (alertController.textFields![1] as UITextField).text!
    //            phoneNumber = (alertController.textFields![2] as UITextField).text!
    //            email = (alertController.textFields![3] as UITextField).text!
    //
    //            let contact = Contact(firstName: firstName, lastName: lastName, email: phoneNumber, phoneNumber: email)
    //
    //            DataManager.sharedManager.contacts.append(contact)
    //
    //            self.tableView.reloadData()
    //        }
    //
    //        alertController.addAction(addAction)
    //
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    //
    //        alertController.addAction(cancelAction)
    //
    //
    //        alertController.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "First name"
    //        }
    //
    //        alertController.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "Last Name"
    //        }
    //
    //        alertController.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "Phone Number"
    //            textField.keyboardType = .PhonePad
    //        }
    //
    //        alertController.addTextFieldWithConfigurationHandler { (textField) in
    //            textField.placeholder = "Email address"
    //            textField.keyboardType = .EmailAddress
    //        }
    //
    //        self.presentViewController(alertController, animated: true, completion: nil)
    //    }
    
    //MARK: Deleting contact directly in tableview instead of in DetailsVC
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        if editingStyle == .Delete {
    //
    //            let contactID = DataManager.sharedManager.contacts[indexPath.row].contactId
    //
    //            DataManager.sharedManager.deleteContact(contactID)
    //
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //        }
    //    }
    
//    private func loadContactListFromDataManager(){
        //        //load list of contacts from documents directory
        //        if let contactFile = DataManager.sharedManager.readContactsFromDirectory() {
        //
        //            DataManager.sharedManager.contacts = contactFile
        //
        //        } else {
        //            //dummy list of contacts
        ////            DataManager.sharedManager.getContacts()
        //
        //            DataManager.sharedManager.fetchContacts()
        //        }
    
//        }

}

