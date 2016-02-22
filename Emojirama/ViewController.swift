//
//  ViewController.swift
//  CollectionView
//
//  Created by Peter Lafferty on 16/09/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var emoji: Emoji?
    let skinTones = ["🏿", "🏾", "🏽", "🏼", "🏻", ""]
    
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
        
        if e.hasSkinTone {
            var items = [UIBarButtonItem]()
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
            
            for tone in skinTones {
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
            self.toolbarItems = items
        }
        
        self.desc.text = "Description: " + e.description
        self.tags.text = "Tags: " + e.tags.joinWithSeparator(", ")
        
        if e.version.isEmpty == false {
            self.version.text = "From Unicode: " + e.version
        } else {
            self.version.text = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSkinTone(sender:AnyObject) {
        if let button = sender as? UIBarButtonItem {
            self.value.text = button.title
        }
    }
    
    @IBAction func copyEmoji(sender: AnyObject) {
        guard let e = emoji else {
            return
        }
        UIPasteboard.generalPasteboard().string = e.value
    }
    
}

