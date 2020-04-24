//
//  EntryOptionViewControllerTests.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-24.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC

class EntryOptionViewControllerTests: XCTestCase {
    
    let entryOptionViewController: EntryOptionViewController? = {
        return UIStoryboard.viewController(.entryOptionController, .landingPage) as? EntryOptionViewController
    }()
    
    var selectedOption: EntryOption?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let _ = self.entryOptionViewController?.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTitles() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(EntryOptionViewController.titles.count == EntryOption.allCases.count)
    }
    
    func testOutlet() throws {
        XCTAssertNotNil(self.entryOptionViewController)
        XCTAssertNotNil(entryOptionViewController?.optionButtons)
        guard let optionButtons: [UIButton] = entryOptionViewController?.optionButtons else {
            XCTAssert(false)
            return
        }
        XCTAssert(optionButtons.count == EntryOption.allCases.count)
        
        for i in 0 ..< optionButtons.count {
            let button = optionButtons[i]
            let title = EntryOptionViewController.titles[i]
            XCTAssert(button.title(for: .normal) == title)
        }
        
    }
    
    func testAction() throws {
        let expectation = XCTestExpectation(description: "Entry Option Action")
        entryOptionViewController?.delegate = self
        entryOptionViewController?.entryAction(entryOptionViewController?.optionButtons[0])
        setTimeout(time: 0.5) {
            XCTAssertNotNil(self.selectedOption)
            if let option = self.selectedOption {
                XCTAssert(option == EntryOption.allCases[0])
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.7)
        
    }
}

extension EntryOptionViewControllerTests: EntryOptionDelegate {
    func didSelect(entryOption: EntryOption) {
        self.selectedOption = entryOption
    }
}
