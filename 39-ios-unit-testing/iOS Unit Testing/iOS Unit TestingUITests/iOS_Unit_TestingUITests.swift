//
//  iOS_Unit_TestingUITests.swift
//  iOS Unit TestingUITests
//
//  Created by Brian Sipple on 3/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import XCTest

class iOS_Unit_TestingUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialCellCount() {
        let tables = XCUIApplication().tables
        let expected = 7
        let actual = tables.cells.count
        
        XCTAssertEqual(actual, expected, "cell count did not match \(expected)")
    }
    
    
    func testFilteringDialog() {
        let app = XCUIApplication()
        app.navigationBars["📜 Shakespeare Word Count"].buttons["🎯 Filter"].tap()
        
        let alertDialog = app.alerts["Show words that include:"]

        alertDialog.textFields.element.typeText("truth")
        alertDialog.buttons["OK"].tap()
        
        let expected = 4
        let actual = app.tables.cells.count
        
        XCTAssertEqual(actual, expected, "table view did not contain \(expected) cells")
    }

}
