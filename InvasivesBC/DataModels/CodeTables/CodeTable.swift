//
//  CodeTable.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-05-11.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CodeTable: Object {
    @objc dynamic var localId: String = {
        return UUID().uuidString
    }()
    
    override class func primaryKey() -> String? {
        return "localId"
    }
    
    @objc dynamic var type: String = ""
    @objc dynamic var displayLabel: String = ""
    @objc dynamic var descriptionLabel: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var activeIndicator: Bool = true
    @objc dynamic var remoteId: Int = -1
}
