//
//  DetailsVC.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/18/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController{
    
    //MARK: Properties
    @IBOutlet var txtFldFirstName: UITextField!
    @IBOutlet var txtFldLastName: UITextField!
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var txtFldPhone: UITextField!
    @IBOutlet weak var segCtrlGender: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var txtFldAddress: UITextField!
    
    
    var selectedContact: Contact?
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateFields()
        
    }
    
    func populateFields(){
        
        if let contact = selectedContact{
            self.txtFldFirstName.text = contact.firstName
            self.txtFldLastName.text = contact.lastName
            self.txtFldEmail.text = contact.email
            self.txtFldPhone.text = contact.phoneNumber
            
            if let gender = contact.gender?.rawValue {
            self.segCtrlGender.selectedSegmentIndex = gender
            }
            
            self.birthDatePicker.date = contact.birthDate
            
            self.txtFldAddress.text = contact.address
        }
       
    }
    
    @IBAction func saveContactChanges() {
        self.selectedContact?.firstName = self.txtFldFirstName.text!
        self.selectedContact?.lastName = self.txtFldLastName.text!
        self.selectedContact?.email = self.txtFldEmail.text!
        self.selectedContact?.phoneNumber = self.txtFldPhone.text!
        self.selectedContact?.gender = Gender(rawValue: self.segCtrlGender.selectedSegmentIndex)
        self.selectedContact?.birthDate = self.birthDatePicker.date
        self.selectedContact?.address = self.txtFldAddress.text!
        
        DataManager.sharedManager.updateContact(selectedContact!)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteContact(){
        if let contact = selectedContact {
            
            DataManager.sharedManager.deleteContact(contact.contactId)
            
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
   
}
