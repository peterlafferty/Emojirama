//
//  TodayViewController.swift
//  Today Extension Today Extension
//
//  Created by Peter Lafferty on 16/11/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit
import NotificationCenter
import EmojiramaKit

class TodayViewController: UIViewController, NCWidgetProviding {
    static let numberOfMinutes = 5

    @IBOutlet weak var openAppButton: UIButton!

    @IBOutlet weak var label: UILabel!
    var emojirama = Emojirama()
    var emoji = Emoji()

    var displayString: String {
        get {
            if emoji.value.isEmpty {
                return "loading..."
            } else {
                return "What does \(emoji.value) mean?"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        emoji = loadEmoji()
        openAppButton.setTitle(displayString, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.NoData)
    }


    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    @IBAction func launchApplication(sender: AnyObject) {
        let emojiString = emoji.value.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.alphanumericCharacterSet())!
        let string = "emojirama://view/\(emojiString)/?modifier=1"
        if let url = NSURL(string: string) {
            extensionContext?.openURL(url, completionHandler: nil)
        }
    }

    func loadEmoji() -> Emoji {
        let defaults = NSUserDefaults.standardUserDefaults()
        let emoji: Emoji

        if let savedEmojiValue: String = defaults.stringForKey("emoji"),
            saveDate = defaults.objectForKey("saveDate") as? NSDate
            where Int(NSDate().timeIntervalSinceDate(saveDate) / 60) < TodayViewController.numberOfMinutes {
            let filteredEmoji = emojirama.filter(savedEmojiValue)
            if filteredEmoji.count > 0 {
                emoji = filteredEmoji[0]
            } else {
                emoji = emojirama.random()
            }
        } else {
            emoji = emojirama.random()

            defaults.setObject(emoji.value, forKey: "emoji")
            defaults.setObject(NSDate(), forKey: "saveDate")
            defaults.synchronize()

        }

        return emoji
    }
}
