//
//  TestUtility.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-05-13.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import XCTest
@testable import InvasivesBC

/// Utility class for common test actions
class TestUtility {
    /// Test code table name
    static let TestCodeTable = "TestCode"
    
    /// Create Test Code table in db
    static func createTestCodes() {
        // Check table already exists or not
        if CodeTable.fetch(type: TestCodeTable) == nil {
            // Creating table
            let table = CodeTable()
            
            // Test code creation closure
            let createCode = { (index: Int) in
                let code = CodeObject()
                code.remoteId = index
                code.remoteDescription = "Test Code \(index)"
                table.codes.append(code)
            }
            
            // Create Test codes
            createCode(1)
            createCode(2)
            createCode(3)
            
            // Save
            RealmRequests.saveObject(object: table)
            
        }
    }
}
