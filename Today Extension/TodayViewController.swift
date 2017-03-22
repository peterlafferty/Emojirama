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
        if emoji.value.isEmpty {
            return "loading..."
        } else {
            return "What does \(emoji.value) mean?"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        emoji = loadEmoji()
        openAppButton.setTitle(displayString, for: UIControlState())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.noData)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    @IBAction func launchApplication(_ sender: AnyObject) {
        let emojiString = emoji.value.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.alphanumerics)!
        let string = "emojirama://view/\(emojiString)/?modifier=1"
        if let url = URL(string: string) {
            extensionContext?.open(url, completionHandler: nil)
        }
    }

    func loadEmoji() -> Emoji {
        let defaults = UserDefaults.standard
        let emoji: Emoji

        //only update today extension if time has passed
        if let savedEmojiValue: String = defaults.string(forKey: "emoji"),
            let saveDate = defaults.object(
                forKey: "saveDate") as? Date,
                Int(Date().timeIntervalSince(saveDate) / 60
                ) < TodayViewController.numberOfMinutes {
            let filteredEmoji = emojirama.filter(savedEmojiValue)
            if filteredEmoji.count > 0 {
                emoji = filteredEmoji[0]
            } else {
                emoji = emojirama.random()
            }
        } else {
            emoji = emojirama.random()

            defaults.set(emoji.value, forKey: "emoji")
            defaults.set(Date(), forKey: "saveDate")
            defaults.synchronize()

        }

        return emoji
    }
}
