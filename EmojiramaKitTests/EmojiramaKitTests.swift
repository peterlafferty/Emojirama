//
//  EmojiramaTests.swift
//  EmojiramaTests
//
//  Created by Peter Lafferty on 22/11/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import XCTest
@testable import EmojiramaKit

class EmojiramaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmojiInit() {
        let emoji = Emoji()
        XCTAssertNotNil(emoji, "why do this test?")
        
    }

    func testEmojiramaInit() {
        let emojirama = Emojirama()
        XCTAssertGreaterThanOrEqual(emojirama.unfilteredEmojis.count, 1, "Emojis not loaded")
        
    }
    
    
    func testTotalCount() {
        let emojirama = Emojirama()
        
        XCTAssertEqual(1281, emojirama.unfilteredEmojis.count, "Wrong number of emoji loaded")
        
    }
    
    func testFilter() {
        let emojirama = Emojirama()
        
        XCTAssertEqual(26, emojirama.filter("zodiac").count, "There should be 26 emoji with zodiac tags")
    }
    
    func testFilterByValue() {
        let emojirama = Emojirama()
        let bearEmoji = emojirama.filter(byValue:"🐻")
        XCTAssertNotNil(bearEmoji, "should be one emoji")
    }
    
    func testFilterByValueNoResults() {
        let emojirama = Emojirama()
        let nilEmoji = emojirama.filter(byValue: "asdasdsadasdasdasdasdad")
        XCTAssertNil(nilEmoji)
    }

    func testFilterWithEmptyString() {
        let emojirama = Emojirama()
        XCTAssertEqual(1281, emojirama.filter("").count, "Wrong number of emoji loaded")
    }

    func testRandom() {
        let emojirama = Emojirama()
        XCTAssertNotNil(emojirama.random(), "should be one emoji")
    }
        
    func testPerformanceOfSetup() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            Emojirama().filter("nature")
            
        }
    }
    
}
