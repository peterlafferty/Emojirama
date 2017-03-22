//
//  ViewController.swift
//  CollectionView
//
//  Created by Peter Lafferty on 16/09/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit
import EmojiramaKit

class ViewController: UIViewController {
    var emoji: Emoji?
    let skinTones = ["🏿", "🏾", "🏽", "🏼", "🏻", ""]
    var currentSelectedValue = ""
    var activity: NSUserActivity?

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var version: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let e = emoji else {
            return
        }

        //self.title = e.value

        value.text = e.value
        currentSelectedValue = e.value

        toolbarItems = createToolbarItems(e)

        desc.text = "Description: " + e.text
        tags.text = "Tags: " + e.tags.joined(separator: ", ")

        if e.version.isEmpty == false {
            version.text = "From Unicode: " + e.version
        } else {
            version.text = ""
        }

        if #available(iOS 9.0, *) {
            activity = NSUserActivity(activityType: "com.peterlafferty.emojirama.view")
            activity?.isEligibleForHandoff = false
            activity?.isEligibleForPublicIndexing = false
            activity?.isEligibleForSearch = true

            activity?.title = "\(e.value) - \(e.text)"
            activity?.keywords = Set(e.tags)
            activity?.keywords.insert("emoji")
            activity?.userInfo = ["emoji.value": e.value]

            activity?.becomeCurrent()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSkinTone(_ sender: AnyObject) {
        if let button = sender as? UIBarButtonItem {
            self.value.text = button.title
            if let value = button.title {
                currentSelectedValue = value
            }
        }
    }

    func share(_ sender: AnyObject) {
        guard let e = emoji else {
            return
        }

        UIPasteboard.general.string = currentSelectedValue

        let textToShare = "\(e.value), \(e.text) @emojirama https://appsto.re/ie/4b-q-.i"

        let objectsToShare = [textToShare, screenshot()] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        if let shareButton = sender as? UIBarButtonItem {
            activityVC.popoverPresentationController?.barButtonItem = shareButton
            present(activityVC, animated: true, completion: nil)
        }
    }

    func screenshot() -> Data {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIImageJPEGRepresentation(image!, 0.7)!
    }

    @IBAction func copyEmoji(_ sender: AnyObject) {
        UIPasteboard.general.string = currentSelectedValue
    }

    @available(iOS 9, *)
    override var previewActionItems: [UIPreviewActionItem] {
        let copyAction = UIPreviewAction(title: "Copy", style: .default, handler: { (_, viewController) -> Void in
            guard let viewController = viewController as? ViewController,
                let emoji = viewController.emoji
                else { return }
            UIPasteboard.general.string = emoji.value
        })

        return [copyAction]
    }

    fileprivate func createToolbarItems(_ emoji: Emoji) -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        if emoji.hasSkinTone {
            for tone in skinTones {
                items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))

                let barButtonItem = UIBarButtonItem(
                    title: emoji.value + tone,
                    style: UIBarButtonItemStyle.plain,
                    target: self,
                    action: #selector(ViewController.updateSkinTone(_:))
                )

                items.append(barButtonItem)
                items.append(
                    UIBarButtonItem(
                        barButtonSystemItem: .flexibleSpace,
                        target: nil,
                        action: nil
                    )
                )
            }
        } else {
            //make sure the share button is on the right
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }

        //add button for sharing
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(ViewController.share(_:))
        )
        items.append(shareButton)

        return items
    }
}
