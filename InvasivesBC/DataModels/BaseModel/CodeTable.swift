//
//  CodeTable.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-13.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


// MARK: Code Table
class CodeTable: Object {
    // MARK: LocalId: Unique value
    @objc dynamic var localId: String = {
        return UUID().uuidString
    }()
    
    // MARK: Primary key
    override class func primaryKey() -> String? {
       return "localId"
    }
    
    // MARK: Type or CodeTable Remote Model Name
    @objc dynamic var type: String = ""
    
    // MARK: List of Values
    var codes: List<CodeObject> = List<CodeObject>()
}

// MARK: CodeTable Functional expansion
extension CodeTable {
    /// List of displayable strings
    var codeStrings: [String] {
        return self.codes.map { $0.remoteDescription }
    }
}
