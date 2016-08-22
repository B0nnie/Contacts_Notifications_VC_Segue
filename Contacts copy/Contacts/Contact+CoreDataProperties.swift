//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Ebony Nyenya on 8/21/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {
    
    @NSManaged var address: String?
    @NSManaged var birthDate: NSDate?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var id: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var gender: NSNumber?
    
}
