//
//  DynamicValueTest.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC
class DynamicValueTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // Test to check DynamicValue
    // 1. Adding observer with immediate value chanage
    // 2. Update value observation
    // 3. Remove
    func testDynamicValue() {
        // Observer
        let observer: NSString = "obs" as NSString
        
        // Dynamic object
        let notifier: DynamicValue<String> = DynamicValue<String>("Laba")
        
        // Adding observer
        notifier.addAndNotify(observer: observer) { v in
            XCTAssert(v == "Laba" || v == "Muna")
        }
        
        // Updating value
        notifier.value = "Muna"
        
        // Removing
        XCTAssertNotNil(notifier.remove(observer: observer))
    }

}
