//
//  AppDelegate.swift
//  Emojirama
//
//  Created by Peter Lafferty on 29/09/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import EmojiramaKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Fabric.with([Crashlytics.self()])
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.preferredDisplayMode = .AllVisible
            
            splitViewController.preferredPrimaryColumnWidthFraction = 0.5
            splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
        }

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if url.scheme == "emojirama" {
            if let _ = url.host where url.host == "view" {
                if let value = url.lastPathComponent {
                    if let emoji = Emojirama().filter(byValue: value) {
                        displayEmoji(emoji)
                    }
                }
            }
        }
        return true
    }
    
    func displayEmoji(emoji:Emoji) {
        print(emoji)
        if let splitViewController = window?.rootViewController as? UISplitViewController {
           
            if let viewController = UIStoryboard(name: "Main", bundle:
                nil).instantiateViewControllerWithIdentifier("emojiViewController") as? ViewController {
                    viewController.emoji = emoji
                    let navController = UINavigationController(rootViewController: viewController)
                    splitViewController.showDetailViewController(navController, sender: self)

            }
        }
        
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    // Collapse the secondary view controller onto the primary view controller.
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        //this stops the blank detail view controller from being shown on ipad portrait
        return true
    }
    
    // Separate the secondary view controller from the primary view controller.
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        return nil
    }
}