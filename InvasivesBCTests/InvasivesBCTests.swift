//
//  InvasivesBCTests.swift
//  InvasivesBCTests
//
//  Created by Amir Shayegh on 2020-04-03.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC


class InvasivesBCTests: XCTestCase {
    func testStringExtension() {
        let testString = "helloWorld"
        let snake = testString.snakeCased()
        XCTAssert(snake == "hello_world")
        let sentence = testString.camelCaseToSentence()
        XCTAssert(sentence == "Hello World")
    }
}
