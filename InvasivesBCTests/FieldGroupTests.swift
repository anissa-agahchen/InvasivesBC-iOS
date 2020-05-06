//
//  FieldGroupTests.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-09.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC
class FieldGroupTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFieldGroup() throws {
        //
        let expectation = XCTestExpectation(description: "Test FieldGroup")
        // Create FieldData
        let fieldText: TextFieldViewModel = TextFieldViewModel(header: "T1", key: "t1", editable: true, data: "TT")
        let fieldTextArea: TextAreaFieldViewModel = TextAreaFieldViewModel(header: "T2", key: "t2", editable: true, data: "TTTTT")
        let fields: [FieldConfig] = [fieldText, fieldTextArea]
        
        // Create Container view
        let container: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        container.backgroundColor = .red
        
        // Create FieldGroupView
        let groupView: FieldGroup = FieldGroup()
        groupView.initialize(with: fields, in: container)
        
        if let window: UIWindow = UIApplication.shared.windows.first {
            window.addSubview(container)
        }
        
        setTimeout(time: 1.0) {
            // Test
            // Number of cell in collection view
            XCTAssert(groupView.collectionView?.numberOfItems(inSection: 0) == fields.count)
            // Test  Cell [0]: should be TextFieldCollectionViewCell
            let cell1: TextFieldCollectionViewCell? = groupView.collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as? TextFieldCollectionViewCell
            XCTAssertNotNil(cell1)
            XCTAssert(cell1?.value == "TT")
            
            // Test  Cell [1]: should be TextFieldCollectionViewCell
            let temp = groupView.collectionView?.cellForItem(at: IndexPath(row: 1, section: 0))
            let cell2: TextAreaFieldCollectionViewCell? = temp as? TextAreaFieldCollectionViewCell
            XCTAssertNotNil(cell2)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
