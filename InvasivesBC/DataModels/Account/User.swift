//
//  User.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// MARK: User Model
class User: BaseObject {
    
    // User's first name
    @objc dynamic var firstName: String = ""
    
    // User's last name
    @objc dynamic var lastName: String = ""
    
    // Email
    @objc dynamic var email: String = ""
    
    // PreferredUsername: User's IDR or BCeID
    @objc dynamic var preferredUsername: String = ""
    
    override class var remotePrimaryKeyName: String {
        return "user_id"
    }
}
