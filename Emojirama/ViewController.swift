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
    var activity:NSUserActivity?
    
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
        
        self.value.text = e.value
        currentSelectedValue = e.value

        var items = [UIBarButtonItem]()
        
        if e.hasSkinTone {
            for tone in skinTones {
                items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))

                let barButtonItem = UIBarButtonItem(
                    title: emoji!.value + tone,
                    style: UIBarButtonItemStyle.Plain,
                    target: self,
                    action: "updateSkinTone:"
                )
                
                items.append(barButtonItem)
                items.append(
                    UIBarButtonItem(
                        barButtonSystemItem: .FlexibleSpace,
                        target: nil,
                        action: nil
                    )
                )
            }
        } else {
            //make sure the share button is on the right
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }

        //add button for sharing
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "share:"
        )
        items.append(shareButton)
        
        self.toolbarItems = items
        
        self.desc.text = "Description: " + e.text
        self.tags.text = "Tags: " + e.tags.joinWithSeparator(", ")
        
        if e.version.isEmpty == false {
            self.version.text = "From Unicode: " + e.version
        } else {
            self.version.text = ""
        }
        
        if #available(iOS 9.0, *) {
            activity = NSUserActivity(activityType: "com.peterlafferty.emojirama.view")
            activity?.eligibleForHandoff = false
            activity?.eligibleForPublicIndexing = false
            activity?.eligibleForSearch = true
            
            activity?.title = "\(e.value): \(e.text)"
            activity?.keywords = Set(e.tags)
            activity?.keywords.insert("emoji")
            activity?.userInfo = ["emoji.value":e.value]
            
            activity?.becomeCurrent()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSkinTone(sender:AnyObject) {
        if let button = sender as? UIBarButtonItem {
            self.value.text = button.title
            if let value = button.title {
                currentSelectedValue = value
            }
        }
    }
    
    func share(sender:AnyObject){
        guard let e = emoji else {
            return
        }
        
        UIPasteboard.generalPasteboard().string = currentSelectedValue

        let textToShare = "\(e.value), \(e.text) @emojirama https://appsto.re/ie/4b-q-.i"
        
        let objectsToShare = [textToShare, screenshot()]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
        if let shareButton = sender as? UIBarButtonItem {
            activityVC.popoverPresentationController?.barButtonItem = shareButton
            presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func screenshot() -> NSData {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageJPEGRepresentation(image, 0.7)!
    }
    
    @IBAction func copyEmoji(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = currentSelectedValue
    }
    
}

