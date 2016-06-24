//
//  EmojiramaUITests.swift
//  EmojiramaUITests
//
//  Created by Peter Lafferty on 29/09/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import XCTest
@testable import Emojirama

class EmojiramaUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPaste() {

        app.searchFields["Search All The Emojis"].tap()
        app.searchFields["Search All The Emojis"].typeText("man")
        app.buttons["Done"].tap()
        
        app.collectionViews.staticTexts["👨"].tap()
        app.toolbars.buttons["👨🏼"].tap()
        app.buttons["Copy"].tap()
        
        let backButtons = app.navigationBars.childrenMatchingType(.Button).matchingIdentifier("Back")
        backButtons.elementBoundByIndex(1).tap()

        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()
        
        app.searchFields["Search All The Emojis"].pressForDuration(1.2);
        app.menuItems["Paste"].tap()
        
        //app.searchFields["Search All The Emojis"].typeText("👨🏼")
        sleep(1)
        XCTAssert(app.cells.staticTexts["👨"].exists, "👨 is shown")
        XCTAssert(app.cells.staticTexts["🏼"].exists, "🏼 is shown")

    }
    
    func testExample() {
        
        app.searchFields["Search All The Emojis"].tap()
        
        app.searchFields["Search All The Emojis"].typeText("man")
        app.buttons["Done"].tap()
        
        app.collectionViews.staticTexts["👨"].tap()
        
        XCTAssert(app.staticTexts["👨"].exists, "👨 is shown")
        XCTAssert(app.staticTexts["Description: man"].exists, "description is shown")
        XCTAssert(app.staticTexts["Tags: man"].exists)
        XCTAssert(app.staticTexts["From Unicode: 2010ʲ"].exists)

        
        XCTAssertEqual(app.toolbars.buttons.count, 7, "there should be 7 buttons")

        app.toolbars.buttons["👨🏿"].tap()
        XCTAssert(app.staticTexts["👨🏿"].exists, "👨🏿 is shown")

        app.toolbars.buttons["👨🏼"].tap()
        XCTAssert(app.staticTexts["👨🏼"].exists, "👨🏼 is shown")
        
        /*'👨🏿''👨🏾''👨🏽''👨🏼''👨🏻''👨'*/

        app.buttons["Copy"].tap()
        
        let backButtons = app.navigationBars.childrenMatchingType(.Button).matchingIdentifier("Back")
        backButtons.elementBoundByIndex(1).tap()

        
        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()

        app.searchFields["Search All The Emojis"].pressForDuration(1.2);
        app.menuItems["Paste"].tap()

        //app.searchFields["Search All The Emojis"].typeText("👨🏼")
        sleep(1)
        XCTAssert(app.cells.staticTexts["👨"].exists, "👨 is shown")
        XCTAssert(app.cells.staticTexts["🏼"].exists, "🏼 is shown")
        
        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()
        
        app.searchFields["Search All The Emojis"].typeText("💩")
        app.collectionViews.staticTexts["💩"].tap()
        
        XCTAssert(app.staticTexts["💩"].exists, "💩 is shown")
        XCTAssert(app.staticTexts["Description: pile of poo"].exists, "description is shown")
        XCTAssert(app.staticTexts["Tags: comic, dung, face, monster, poo, poop"].exists)
        XCTAssert(app.staticTexts["From Unicode: 2010ʲ"].exists)
        XCTAssertEqual(app.toolbars.buttons.count, 1, "there should be 1 button")
        
        app.toolbars.buttons["Share"].tap()
        app.buttons["Cancel"].tap()
        backButtons.elementBoundByIndex(1).tap()

        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()
        
        app.searchFields["Search All The Emojis"].typeText("mán with gu")
        app.buttons["Done"].tap()

        XCTAssertEqual(app.toolbars.buttons.count, 6, "there should be 6 buttons")
        app.toolbars.buttons["🏾"].tap()
        XCTAssert(app.staticTexts["👲🏾"].exists, "👲🏾 is shown")
        app.toolbars.buttons["Stop"].tap()
        XCTAssert(app.staticTexts["👲"].exists, "👲 is shown")

        
        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()
        
        app.searchFields["Search All The Emojis"].typeText("omgnothing")

        
        
        
    }
    
}
