//
//  AppDelegate.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import UIKit
import RIBs
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var launchRouter: LaunchRouting?
    private var urlHandler: URLHandler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let result = AppRootBuilder(dependency: AppComponent()).build()
        self.launchRouter = result.launchRouter
        self.urlHandler = result.urlHandler
        
        launchRouter?.launch(from: window)

        return true
    }
}


protocol URLHandler: AnyObject {
  func handle(_ url: URL)
}
