//
//  InvasivesBCTests.swift
//  InvasivesBCTests
//
//  Created by Amir Shayegh on 2020-04-03.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC

class TestClass: BaseObject {
    @objc dynamic var testProp: String = ""
    @objc dynamic var testDouble: Double = 5.0
    @objc dynamic var base: BaseObject = BaseObject()
}

class InvasivesBCTests: XCTestCase {

}
