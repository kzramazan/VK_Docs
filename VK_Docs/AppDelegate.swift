//
//  AppDelegate.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Pods_VK_Docs
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        launchApp(launchOptions)
        return true
    }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("VK open URL: \(url). Options: \(options.keys)")
//        VKSdk.processOpen(url, fromApplication: options.keys.first?.rawValue)
//        return true
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }
    
}

extension AppDelegate {
    func launchApp(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        VKSdk.initialize(withAppId: Constants.vkAppID)
//        VKSdk.initialize()
        
//        VKSdk.wakeUpSession(["friends", "email", "docs"]) { (state, error) in
//            print("wake up session state: ", state)
//            if error != nil {
//                print("Error in wake up session: ", error?.localizedDescription)
//                return
//            }
//
//            if state == .authorized {
//                VKSdk.authorize(["friends", "email", "docs"])
//            }else {
//
//            }
//
//
//        }
        setupRootViewController()
//        setVKAuth()
//        if let bundleIdentifier = Bundle.main.bundleIdentifier {
//
//
//
//        }
        
//        VKSdk.register()
    }
    
    func setupRootViewController(_ rootViewController: UIViewController = SignInVC()) {
        let vc = rootViewController
        let navigation = UINavigationController(rootViewController: vc)

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
    }
    
    func setVKAuth() {
        let permissionList: [Constants.VKPermission] = [.friends, .email, .docs]
        VKSdk.wakeUpSession(permissionList) { [weak self] (state, error) in
            guard let self = self else { return }
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if state == .authorized {
                let vkApi = VKApi.users()?.get()
                vkApi?.execute(resultBlock: { [weak self] (response) in
                    guard let self = self else { return }
                    let currUser = CurrentUser(object: (response?.json as? NSArray)?[0] as? NSDictionary)
                    if CurrentUser.shared != currUser {
                       CurrentUser.shared = currUser
                    }
                    
                    self.setupRootViewController(DocumentsVC())
                }, errorBlock: { (error) in
                    print(error.debugDescription)
                })
            }else {
                self.setupRootViewController()
            }
        }
    }
}

extension AppDelegate {
}

