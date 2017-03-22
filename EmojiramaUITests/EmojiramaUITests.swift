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
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPaste() {
        sleep(1)
        app.searchFields["Search All The Emojis"].tap()
        app.searchFields["Search All The Emojis"].typeText("man")
        app.buttons["Done"].tap()

        app.collectionViews.staticTexts["👨"].tap()
        app.toolbars.buttons["👨🏼"].tap()
        app.buttons["Copy"].tap()

        let backButtons = app.navigationBars.children(matching: .button).matching(identifier: "Back")
        backButtons.element(boundBy: 1).tap()

        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()

        app.searchFields["Search All The Emojis"].press(forDuration: 1.2)
        app.menuItems["Paste"].tap()

        //app.searchFields["Search All The Emojis"].typeText("👨🏼")
        sleep(1)
        XCTAssert(app.cells.staticTexts["👨"].exists, "👨 is shown")
        XCTAssert(app.cells.staticTexts["🏼"].exists, "🏼 is shown")

    }

    func testSeachForMan() {

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

        let backButtons = app.navigationBars.children(matching: .button).matching(identifier: "Back")
        backButtons.element(boundBy: 1).tap()

        app.searchFields["Search All The Emojis"].buttons["Clear text"].tap()
        app.searchFields["Search All The Emojis"].tap()

        app.searchFields["Search All The Emojis"].press(forDuration: 1.2)
        app.menuItems["Paste"].tap()

        //app.searchFields["Search All The Emojis"].typeText("👨🏼")
        sleep(1)
        XCTAssert(app.cells.staticTexts["👨"].exists, "👨 is shown")
        XCTAssert(app.cells.staticTexts["🏼"].exists, "🏼 is shown")

    }

    func testSearchForPoo() {
        sleep(1)
        app.searchFields["Search All The Emojis"].tap()

        app.searchFields["Search All The Emojis"].typeText("💩")
        app.collectionViews.staticTexts["💩"].tap()

        XCTAssert(app.staticTexts["💩"].exists, "💩 is shown")
        XCTAssert(app.staticTexts["Description: pile of poo"].exists, "description is shown")
        XCTAssert(app.staticTexts["Tags: comic, dung, face, monster, poo, poop"].exists)
        XCTAssert(app.staticTexts["From Unicode: 2010ʲ"].exists)
        XCTAssertEqual(app.toolbars.buttons.count, 1, "there should be 1 button")

        let backButtons = app.navigationBars.children(matching: .button).matching(identifier: "Back")
        app.toolbars.buttons["Share"].tap()
        app.buttons["Cancel"].tap()
        backButtons.element(boundBy: 1).tap()

    }

    func testSearchForGuaPi() {

        app.searchFields["Search All The Emojis"].tap()

        app.searchFields["Search All The Emojis"].typeText("mán with gu")
        app.buttons["Done"].tap()

        XCTAssertEqual(app.toolbars.buttons.count, 6, "there should be 6 buttons")
        app.toolbars.buttons["🏾"].tap()
        XCTAssert(app.staticTexts["👲🏾"].exists, "👲🏾 is shown")
        app.toolbars.buttons["Stop"].tap()
        XCTAssert(app.staticTexts["👲"].exists, "👲 is shown")
    }
}
