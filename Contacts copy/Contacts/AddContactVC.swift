//
//  AddContact.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/30/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit
import CoreData

class AddContactVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var segCtrlGender: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var txtFldAddress: UITextField!
    
    
    //MARK: Methods
    @IBAction func cancel() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNewContact(){
        
        //        let contact = Contact(firstName: txtFldFirstName.text!, lastName: txtFldLastName.text!, email: txtFldEmail.text!, phoneNumber: txtFldPhoneNumber.text!, gender: Gender(rawValue: segCtrlGender.selectedSegmentIndex)!, birthDate: birthDatePicker.date, address: txtFldAddress.text!)
        //
        //        DataManager.sharedManager.addContact(contact)
        
        //create Contact entity object and save it to CoreData database
        if let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: DataManager.sharedManager.managedObjectContext!) as? Contact {
            
            newContact.firstName = txtFldFirstName.text!
            newContact.lastName = txtFldLastName.text!
            newContact.email = txtFldEmail.text!
            newContact.birthDate = birthDatePicker.date
            newContact.address = txtFldAddress.text!
            newContact.phoneNumber = txtFldPhoneNumber.text!
            newContact.id = NSUUID().UUIDString
            newContact.gender = self.segCtrlGender.selectedSegmentIndex
            
            //add new contact to DataManager's array so it'll be displayed in tableview
            DataManager.sharedManager.addContact(newContact)
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}