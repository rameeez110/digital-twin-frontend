//
//  AppDelegate.swift
//  Sould
//
//  Created by Rameez Hasan on 10/08/2022.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SwiftLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        for fontFamilyNames in UIFont.familyNames {
//            for fontName in UIFont.fontNames(forFamilyName: fontFamilyNames) {
//                print("FONTNAME:\(fontName)")
//            }
//        }
        
        IQKeyboardManager.shared.enable = true
        CommonClass.sharedInstance.customizeUINavigationBar()
        CommonClass.sharedInstance.customizeUITabBar()
        CommonClass.sharedInstance.customizeUISearchBar()
        
        GMSServices.provideAPIKey("AIzaSyBv021fbIY4Rs2wdONNxDdKqok5hgTeH6U")
        GMSPlacesClient.provideAPIKey("AIzaSyASSANM7jPmPgfcIITHmfE-n1VUfsNmKdw")
        
        SwiftLocation.credentials[.google] = "AIzaSyASSANM7jPmPgfcIITHmfE-n1VUfsNmKdw"
        
//        google sign in key
//        349642119478-tu8u7t0n7s2t5pla3ni81064fjrq1vu2.apps.googleusercontent.com
        
//        self.registerForPushNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications(){
        if #available(iOS 10, *){
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {return}
                if granted{
                    DispatchQueue.main.async{
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            
            let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
            let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
            center.setNotificationCategories(Set([deafultCategory]))
        }
        else
        {
            let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // MARK:- FOR Forground App Notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("Notification recived in forground state.")
        
        completionHandler([.badge, .sound])
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
}
