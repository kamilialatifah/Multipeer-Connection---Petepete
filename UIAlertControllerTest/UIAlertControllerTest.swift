//
//  UIAlertControllerTest.swift
//  UIAlertControllerTest
//
//  Created by Kamilia Latifah on 19/09/19.
//  Copyright © 2019 masaksendiri. All rights reserved.
//

import XCTest
@testable import petepete

class UIAlertControllerTest: XCTestCase {
    
    //Swift - How do you test whether a label has been updated when a button is tapped//
    
    

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
    
    func testButtonNavigationBarKanan() {
       let app = XCUIApplication()
        app.navigationBars.buttons.element(boundBy: 1).tap()
    }
    
    func testButtonNavigationBarKiri() {
        let app = XCUIApplication()
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
