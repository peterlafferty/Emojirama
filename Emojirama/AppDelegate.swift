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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
           
//            if let viewController = UIStoryboard(name: "Main", bundle:
//                nil).instantiateViewControllerWithIdentifier("bleurgh") as? ViewController {
//                    viewController.schemeString = url.absoluteString
//                    viewController.url = url
//                    navController.viewControllers.append(viewController)
//                    
//            }
            //self.window?.rootViewController = navController
            
            
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