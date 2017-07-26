//
//  AppDelegate.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var wcSessionModule: WatchSessionIOSReceiveReplyModule?
    var quizAppDelegateModule: QuizAppDelegateModule?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let window = self.window {
            quizAppDelegateModule = QuizAppDelegateModule(mainWindow: window)
        }
        
        quizAppDelegateModule?.registerForLocalAndRemoteNotifications(application: application, completionClosure: nil)
        
        setUpWatchSession()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        QuizCoreDataBase().saveContext()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        quizAppDelegateModule?.performDeepLink(from: shortcutItem)
        completionHandler(true)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        quizAppDelegateModule?.performDeepLink(from: url)
        return true
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(tokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        quizAppDelegateModule?.performDeepLink(fromRemoteNotification: userInfo)
    }
    
    func setUpWatchSession() {
        let watchSessionManager = WatchSessionManager.shared
        let watchSessionDataParser = WatchSessionDataParser()
        let watchSessionIOSReplyDataProvider = WatchSessionIOSReplyDataProvider(serverManager: QuizServerManager(),
                                                                                dataParser: watchSessionDataParser)
        
        wcSessionModule = WatchSessionIOSReceiveReplyModule(sessionManager: watchSessionManager,
                                                         replyDataProvider: watchSessionIOSReplyDataProvider)
        wcSessionModule?.startSession()
    }
}
