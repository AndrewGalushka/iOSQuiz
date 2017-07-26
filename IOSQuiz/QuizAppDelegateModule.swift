//
//  QuizAppDelegateModule.swift
//  IOSQuiz
//
//  Created by galushka on 6/30/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

class QuizAppDelegateModule {
    
    let deeplinkManager = DeeplinkManager()
    unowned let mainWindow: UIWindow
    
    init(mainWindow: UIWindow) {
        self.mainWindow = mainWindow
    }
    
    func registerForLocalAndRemoteNotifications(application: UIApplication, completionClosure: (() -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error as NSError? {
                print("\(error.code) \(error.description)")
                
                if let fetchedClosure = completionClosure {
                    fetchedClosure()
                }
            }
        }
        
        application.registerForRemoteNotifications()
    }
    
    func performDeepLink(from url: URL) {
        guard let deepLinkType = deeplinkManager.deepLinkType(from: url) else {
            return
        }
        
        deeplinkManager.processDeepLink(deepLinkType, window: mainWindow)
    }
    
    func performDeepLink(from shortcutItem: UIApplicationShortcutItem) {
        guard let deepLinkType = deeplinkManager.deepLinkType(from: shortcutItem) else {
            return
        }
        
        deeplinkManager.processDeepLink(deepLinkType, window: mainWindow)
    }
    
    func performDeepLink(fromRemoteNotification userInfo: [AnyHashable: Any]) {
        guard let rootDictionary = userInfo["aps"] as? [AnyHashable: Any] else {
            return
        }
        
        guard
            let urlString = rootDictionary["deeplink"] as? String,
            let url = URL(string: urlString) else {
                return
        }
        
        guard let deepLinkType = deeplinkManager.deepLinkType(from: url) else {
            return
        }
        
        deeplinkManager.processDeepLink(deepLinkType, window: mainWindow)
        
    }
}




