//
//  Emojirama.swift
//  TodayExtension
//
//  Created by Peter Lafferty on 20/11/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit

open class Emojirama {
    open var unfilteredEmojis = [Emoji]()
    open var modifiers = ["🏿", "🏾", "🏽", "🏼", "🏻", ""]
    fileprivate let identifier = "com.peterlafferty.EmojiramaKit"
    public init() {
        let identifier = "com.peterlafferty.EmojiramaKit"

        if let path = Bundle(identifier: identifier)?.path(forResource: "emojis", ofType: "json") {
            if let emojiData = try? Data(contentsOf: URL(fileURLWithPath: path)) {

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: emojiData, options: [])

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

    open func filter(_ text: String) -> [Emoji] {
        var emoji: [Emoji]

        if text.isEmpty {
            emoji = unfilteredEmojis
        } else {
            emoji = unfilteredEmojis.filter({ (emoji: Emoji) -> Bool in
                if #available(iOS 9.0, *) {

                    return emoji.text.localizedStandardContains(text)
                        || emoji.tags.joined(separator: ", ").localizedStandardContains(text)
                        || text.localizedStandardContains(emoji.value)

                } else {
                    return emoji.text.contains(text)
                        || emoji.tags.joined(separator: ", ").contains(text)
                        || text.contains(emoji.value)
                }

            })
        }

        return emoji
    }

    open func filter(byValue text: String) -> Emoji? {
        var emoji: [Emoji]

        emoji = unfilteredEmojis.filter({ (emoji: Emoji) -> Bool in
            if #available(iOS 9.0, *) {
                return emoji.value.localizedStandardContains(text)
            } else {
                return emoji.value.contains(text)
            }

        })

        if emoji.count == 1 {
            return emoji[0]
        }
        return nil
    }

    open func random() -> Emoji {
        let index = arc4random_uniform(UInt32(unfilteredEmojis.count))
        return unfilteredEmojis[Int(index)]

    }

}
