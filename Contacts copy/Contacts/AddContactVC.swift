//
//  AddContact.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/30/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var txtFldFirstName: UITextField!
    @IBOutlet var txtFldLastName: UITextField!
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var segCtrlGender: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var txtFldAddress: UITextField!
    
    
    //MARK: Methods
    @IBAction func cancel() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNewContact(){
        
        let contact = Contact(firstName: txtFldFirstName.text!, lastName: txtFldLastName.text!, email: txtFldEmail.text!, phoneNumber: txtFldPhoneNumber.text!, gender: Gender(rawValue: segCtrlGender.selectedSegmentIndex)!, birthDate: birthDatePicker.date, address: txtFldAddress.text!)
        
        DataManager.sharedManager.addContact(contact)
        
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}