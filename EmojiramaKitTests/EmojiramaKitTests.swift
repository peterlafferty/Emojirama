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
    
    func testEmojiInitFail() {
/*
(lldb) po data
▿ 8 elements
▿ [0] : 2 elements
- .0 : description
- .1 : grinning face
▿ [1] : 2 elements
- .0 : type
- .1 : emoji
▿ [2] : 2 elements
- .0 : id
▿ [3] : 2 elements
- .0 : tags
▿ .1 : 3 elements
- [0] : face
- [1] : grin
- [2] : person
▿ [4] : 2 elements
- .0 : code
- .1 : U+1F600
▿ [5] : 2 elements
- .0 : value
- .1 : 😀
▿ [6] : 2 elements
- .0 : version
- .1 : V6.1ˣ
▿ [7] : 2 elements
- .0 : hasSkinTone

(lldb)
*/
        let testData = [String:String]()
        let emoji = Emoji(testData)
        XCTAssertNil(emoji)
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
