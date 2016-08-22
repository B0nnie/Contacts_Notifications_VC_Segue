//
//  Contacts.swift
//  Contacts
//
//  Created by Ebony Nyenya on 7/18/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//
//
//import Foundation
//
//@objc enum Gender: Int32 {
//    case Female //0
//    case Male //1
//}
//
//class OldContact: NSObject, NSCoding {
//    
//    var contactId : String = NSUUID().UUIDString
//    
//    var firstName: String
//    var lastName: String
//    var email: String
//    var phoneNumber: String
//    var gender: Gender?
//    var birthDate: NSDate
//    var address: String?
//    
//    init(firstName: String, lastName: String, email: String, phoneNumber: String, gender: Gender?, birthDate: NSDate, address: String?){
//        
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.phoneNumber = phoneNumber
//        self.gender = gender
//        self.birthDate = birthDate
//        self.address = address
//        
//        super.init()
//    }
//    
//    //encode properties
//    func encodeWithCoder(aCoder: NSCoder) {
//        
//        aCoder.encodeObject(self.firstName, forKey: "FIRSTNAME")
//        aCoder.encodeObject(self.lastName, forKey:"LASTNAME")
//        aCoder.encodeObject(self.email, forKey: "EMAIL")
//        aCoder.encodeObject(self.phoneNumber, forKey: "PHONENUMBER")
//        aCoder.encodeObject(self.gender?.rawValue, forKey: "GENDER")
//        aCoder.encodeObject(self.birthDate, forKey: "BIRTHDATE")
//        aCoder.encodeObject(self.address, forKey: "ADDRESS")
//        
//    }
//    
//    //decode properties
//   required init?(coder aDecoder: NSCoder){
//    self.firstName = aDecoder.decodeObjectForKey("FIRSTNAME") as! String
//    self.lastName = aDecoder.decodeObjectForKey("LASTNAME") as! String
//    self.email = aDecoder.decodeObjectForKey("EMAIL") as! String
//    self.phoneNumber = aDecoder.decodeObjectForKey("PHONENUMBER") as! String
//    
//    if let genderValue = aDecoder.decodeObjectForKey("GENDER") as? Int {
//        self.gender =  Gender(rawValue: genderValue)
//     
//    }
//  
//    self.birthDate = aDecoder.decodeObjectForKey("BIRTHDATE") as! NSDate
//    self.address = aDecoder.decodeObjectForKey("ADDRESS") as? String
//    
//    super.init()
//    
//    }
//    
//    
//}