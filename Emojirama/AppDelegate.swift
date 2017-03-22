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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self()])

        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.preferredDisplayMode = .allVisible

            splitViewController.preferredPrimaryColumnWidthFraction = 0.5
            splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
        }

        return true
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        if url.scheme == "emojirama" {
            if let _ = url.host, url.host == "view" {
                if !url.lastPathComponent.isEmpty {
                    if let emoji = Emojirama().filter(byValue: url.lastPathComponent) {
                        displayEmoji(emoji)
                    }
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "emojirama" {
            if let _ = url.host, url.host == "view" {
                if !url.lastPathComponent.isEmpty {
                    if let emoji = Emojirama().filter(byValue: url.lastPathComponent) {
                        displayEmoji(emoji)
                    }
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == "com.peterlafferty.emojirama.view" {
            if let userInfo = userActivity.userInfo {
                if let value = userInfo["emoji.value"] as? String {
                    if let emoji = Emojirama().filter(byValue: value) {
                        displayEmoji(emoji)
                    }

                }
            }
        }

        return true
    }

    func displayEmoji(_ emoji: Emoji) {

        if let splitViewController = window?.rootViewController as? UISplitViewController {

            if let viewController = UIStoryboard(name: "Main", bundle:
                nil).instantiateViewController(withIdentifier: "emojiViewController") as? ViewController {
                    viewController.emoji = emoji
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.isToolbarHidden = false
                    splitViewController.showDetailViewController(navController, sender: self)

            }
        }

    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    // Collapse the secondary view controller onto the primary view controller.
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        //this stops the blank detail view controller from being shown on ipad portrait
        return true
    }

    // Separate the secondary view controller from the primary view controller.
    // swiftlint:disable:next line_length
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        return nil
    }
}
