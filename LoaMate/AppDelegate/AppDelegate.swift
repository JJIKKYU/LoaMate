//
//  AppDelegate.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import UIKit
import RIBs
import RealmSwift
// import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var launchRouter: LaunchRouting?
    private var urlHandler: URLHandler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // FirebaseApp.configure()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let result = AppRootBuilder(dependency: AppComponent()).build()
        self.launchRouter = result.launchRouter
        self.urlHandler = result.urlHandler
        
        launchRouter?.launch(from: window)
        let realm = Realm.safeInit()
        print("Realm Location = \(String(describing: realm?.configuration.fileURL))")

        return true
    }
}


protocol URLHandler: AnyObject {
  func handle(_ url: URL)
}
