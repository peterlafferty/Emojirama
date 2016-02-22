//
//  Emojirama.swift
//  TodayExtension
//
//  Created by Peter Lafferty on 20/11/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit

public class Emojirama {
    public var unfilteredEmojis = [Emoji]()
    public var modifiers = ["🏿", "🏾", "🏽", "🏼", "🏻", ""]
    
    public init() {

        if let path = NSBundle(identifier: "com.peterlafferty.Emojirama")?.pathForResource("emojis", ofType: "json") {
            if let emojiData = NSData(contentsOfFile: path) {
                
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(emojiData, options: [])
                    
                    if let jsonDict = jsonObject as? [NSDictionary] {
                        for value in jsonDict {
                            if let emoji = Emoji(value) {
                                unfilteredEmojis.append(emoji)
                            }
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
        }
        
    }

    public func filter(text:String) -> [Emoji] {
        var emoji:[Emoji]
        
        if text.isEmpty {
            emoji = unfilteredEmojis
        } else {
            emoji = unfilteredEmojis.filter({ (emoji:Emoji) -> Bool in
                if #available(iOS 9.0, *) {
                    
                    return emoji.text.localizedStandardContainsString(text)
                        || emoji.tags.joinWithSeparator(", ").localizedStandardContainsString(text)
                        || text.localizedStandardContainsString(emoji.value)
                    
                } else {
                    return emoji.text.containsString(text)
                        || emoji.tags.joinWithSeparator(", ").containsString(text)
                        || text.containsString(emoji.value)
                }
                
            })
        }
        
        return emoji
    }
    
    public func filter(byValue text:String) -> Emoji? {
        var emoji: [Emoji]
        
        emoji = unfilteredEmojis.filter({ (emoji:Emoji) -> Bool in
            if #available(iOS 9.0, *) {
                return emoji.value.localizedStandardContainsString(text)
            } else {
                return emoji.value.containsString(text)
            }
            
        })

        if emoji.count == 1 {
            return emoji[0]
        }
        return nil
    }
    
    public func random() -> Emoji {
        let index = arc4random_uniform(UInt32(unfilteredEmojis.count))
        return unfilteredEmojis[Int(index)]

    }

}
