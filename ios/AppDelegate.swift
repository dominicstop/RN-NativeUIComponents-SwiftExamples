//
//  AppDelegate.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?;
  var bridge: RCTBridge!;

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.bridge = RCTBridge(delegate: self, launchOptions: launchOptions);
    
    #if DEBUG
    // Fixes Warning:
    // RCTBridge required dispatch_sync to load RCTDevLoadingView. This may lead to deadlocks
    self.bridge.module(for: RCTDevLoadingView.self);
    #endif
    
    let rootView = RCTRootView(
      bridge           :  self.bridge,
      moduleName       :  "nativeUIModulesTest",
      initialProperties:  nil
    );
    
    rootView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
    
    let rootVC = UIViewController();
    rootVC.view = rootView;
    
    self.window = {
      let window = UIWindow(frame: UIScreen.main.bounds);
      window.rootViewController = rootVC;
      window.makeKeyAndVisible();
      return window;
    }();
    
    return true;
  };

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  };

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  };

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  };

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  };

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  };
};

extension AppDelegate: RCTBridgeDelegate {
  func sourceURL(for bridge: RCTBridge!) -> URL {
    #if DEBUG
    print("DEBUG: using RCTBundleURLProvider");
    
    return RCTBundleURLProvider
      .sharedSettings()
      .jsBundleURL(forBundleRoot: "index", fallbackResource: nil);
    
    #else
    return Bundle.main.url(forResource: "main", withExtension: "jsbundle")!;
    #endif
  };
};
