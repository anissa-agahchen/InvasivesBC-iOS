//
//  AppDelegate.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-03.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

class AppLogDataSource: NSObject, LoggerDataSource {
    var csvLogFileName: String = "app_logger.csv"
    var logFileName: String = "app_logger.txt"
    var maxSize: Int = 1024 * 1024 * 1
    var appNamePrefix: String = "InvasivesBC"
    var timeFormat: String = "dd-MMM-yy HH:mm:ss"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Start Logging
        // Setup App Name
        SetAppName("InvasivesBC")
        // Setup Logger
        LoggerSetDataSource(AppLogDataSource())
        // Start Logging
        ApplicationLogger.defalutLogger.start()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

