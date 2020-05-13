//
//  BaseObject.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: BaseObject
// BaseObject for all data model classes
class BaseObject: Object {
    // MARK: LocalId: Unique value
    @objc dynamic var localId: String = {
        return UUID().uuidString
    }()
    // MARK: Primary key
    override class func primaryKey() -> String? {
       return "localId"
    }
    
    // MARK: Model Properties
    // MARK: Remote Primary key
    @objc dynamic var remoteId: Int = -1
    // MARK: Display label
    @objc dynamic var displayLabel: String = ""
    // MARK: Sync Indicator
    @objc dynamic var sync: Bool = false
    
    // MARK: Remote Primary key mapper: Model subclass must override
    class var remotePrimaryKeyName: String {
        return ""
    }
    
    // MARK: Property List
    static func propertyList() -> [PropertyDescriptor] {
        var final: [PropertyDescriptor] = []
        final.append(contentsOf: BaseObject.getPropertyList())
        final.append(contentsOf: self.getPropertyList())
        return final
    }
}

// MARK: Generic Code Table
class CodeObject: BaseObject {
    // MARK: Remote description
    @objc dynamic var remoteDescription: String = ""
    @objc dynamic var primaryKeyName: String = ""
}
