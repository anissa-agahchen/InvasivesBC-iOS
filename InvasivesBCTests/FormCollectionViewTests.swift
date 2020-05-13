//
//  FormCollectionViewTests.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-05-12.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC

/// This test is standard test suit to test any Model-Form ViewController
class FormCollectionViewTests: XCTestCase {
    
    // Test Target Form Controller
    var userFormViewController: UserFormViewController? = {
        return UIStoryboard.viewController(.userFormController, .forms) as? UserFormViewController
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// This test will  explain how to use form collection view controller to create a custom form
    func testFormViewController() throws {
        // Create expectation for async test
        let expectation = XCTestExpectation(description: "Test FormViewController")
        
        // Now get specific FormViewController of User Model
        XCTAssertNotNil(self.userFormViewController)
        XCTAssertNotNil(self.userFormViewController?.view)
        XCTAssertNotNil(self.userFormViewController?.collectionView)
        XCTAssertNotNil(self.userFormViewController?.formModel)
        
        // Now Display in window
        if let window: UIWindow = UIApplication.shared.windows.first, let view = self.userFormViewController?.view, let collectionView = self.userFormViewController?.collectionView, let model: UserFormViewModel = self.userFormViewController?.formModel {
            window.addSubview(view)
            
            // Set timeout and check
            setTimeout(time: 0.5) {
                // Check group count
                let section = collectionView.numberOfItems(inSection: 0)
                XCTAssert(section == model.groups.count)
                
                // Check Cell
                guard let cell: FormGroupCollectionViewCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormGroupCollectionViewCell else {
                    XCTFail()
                    return
                }
                
                // Now check fieldGroup view
                XCTAssertNotNil(cell.fieldGroupView)
                
                guard let fieldView = cell.fieldGroupView, let groupCollectionView = fieldView.collectionView else {
                    XCTFail()
                    return
                }
                
                let group: UserFormViewModel.FieldGroup = model.groups[0]
                
                // Check group view count
                XCTAssert(group.fields.count == groupCollectionView.numberOfItems(inSection: 0))
                
                // Now check first cell / firstNameCell
                let firstNameCell: TextFieldCollectionViewCell? = groupCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as?  TextFieldCollectionViewCell
                XCTAssertNotNil(firstNameCell)
                
                // Finishing test
                expectation.fulfill()
            }
            
            // Add wait test to complete for 2.0 sec
            wait(for: [expectation], timeout: 2.0)
        } else {
            // Fail
            XCTFail()
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
