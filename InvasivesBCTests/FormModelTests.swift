//
//  FormModelTests.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-05-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC

let GroupHeader = "All Field In Same Group"
class UserTestViewModel: FormModel<User> {
    override var layout: Layout {
        var layout: Layout = Layout()
        var group: Layout.Group = Layout.Group()
        group.header = GroupHeader
        group.fields = [
            ("firstName", .Half),
            ("lastName", .Half),
            ("email", .Half)
        ]
        layout.groups = [group]
        return layout
    }
}

class FormModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPropertyList() throws {
        let list = User.propertyList()
        XCTAssert(list.count == 8)
    }

    /// Testing layout structure of the FormModel
    func testLayout() {
        // Create VM object
        let vm: UserTestViewModel = UserTestViewModel()
        // Creating Fields
        vm.createFields()
        // Getting group
        let groups: [FormModel.FieldGroup] = vm.groups
        XCTAssert(groups.count == 2)
        // Test Group 1
        let group1:FormModel.FieldGroup = groups[0]
        XCTAssert(group1.header == GroupHeader)
        // Test Field1
        let field0: Field = group1.fields[0]
        XCTAssert(field0.key == "firstName")
        XCTAssert(field0.header == "First Name")
        
        // Check Other groups
        let group2: FormModel.FieldGroup = groups[1]
        XCTAssert(group2.header == UngroupedFieldsGroupHeader)
        XCTAssert(group2.fields.count == User.propertyList().count - 7)
        
        // Check ignored props
        let ignoredField: Field? = vm[SelectorStr(#selector(getter: BaseObject.localId))]
        XCTAssertNil(ignoredField)
        
    }
    
    /// Testing Value Change Observation of FormModel
    func testValueChange() {
        // View Model
        let vm: UserTestViewModel = UserTestViewModel()
        // Data Model
        let user: User = User()
        user.firstName = "Test"
        user.lastName = "FW"
        
        // Adding model to View Model
        vm.data = user
        
        // Check Field Value
        // Get Field from map
        let field: Field? = vm["firstName"]
        let fieldStringValue: String = field?.fieldValue as? String ?? ""
        XCTAssert(fieldStringValue == "Test")
        // Change
        let testFirstName = "InvasivesBC"
        field?.fieldValue = testFirstName
        
        // Check model property
        XCTAssert(user.firstName == testFirstName)
        
        // Test Clear fields observer
        vm.clearFieldsObserver()
        let testFirstName2 = "BCGov"
        field?.fieldValue = testFirstName2
        XCTAssert(user.firstName != testFirstName2)
        
    }
    
    func testIgnoredProperties() {
        let ignoredPropList = UserTestViewModel.ignoredProperties()
        XCTAssert(ignoredPropList.count == 4)
        XCTAssert(ignoredPropList.contains("localId"))
        XCTAssert(ignoredPropList.contains("remoteId"))
        XCTAssert(ignoredPropList.contains("displayLabel"))
        XCTAssert(ignoredPropList.contains("sync"))
    }

    /*func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
