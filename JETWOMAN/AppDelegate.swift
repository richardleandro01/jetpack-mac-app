//
//  AppDelegate.swift
//  JETWOMAN
//
//  Created by richardleandro on 08/04/19.
//  Copyright © 2019 richardleandro. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func resetScoreClicked(_ sender: Any) {
        print("Reset High Score")
        UserDefaults.standard.set(0, forKey: "highscore")
        UserDefaults.standard.synchronize()
        if let VC = NSApplication.shared.windows.first?.contentViewController as?
            ViewController{
            if let scene = VC.skView.scene as? GameScene{
                scene.updateHighScore()
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
