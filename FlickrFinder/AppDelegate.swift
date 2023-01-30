//
//  AppDelegate.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var coordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(
            mainWindow: window!
        )
        coordinator.appDidLaunch(options: launchOptions)
        return true
    }
}

