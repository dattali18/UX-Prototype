//
//  SceneDelegate.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
            // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
            // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
            guard let _ = (scene as? UIWindowScene) else { return }
            
//            CoreDataManager.shared.deleteAll(Assignment.self)
//            CoreDataManager.shared.deleteAll(Resource.self)
//            CoreDataManager.shared.deleteAll(Semester.self)
//            CoreDataManager.shared.deleteAll(Course.self)
//            CoreDataManager.shared.deleteAll(GradeItem.self)
//            MockDataManager.shared.CreateMockData()
            
//            let storyboard = UIStoryboard (name: "Main", bundle: nil)
//            let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
//            window?.rootViewController = CustomTB
            
//            window?.rootViewController = UIHostingController(rootView: CoursesListView())
//            window?.rootViewController = UIHostingController(rootView: AssignmentListView())
            
            window?.rootViewController = UIHostingController(rootView: MainTabBarView())
            window?.makeKeyAndVisible()
        }
    
        func changeScreen() {
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            
            if (UserLogin.shared.loggedIn()) {
                //if user is logged in go to the tab controller
                // set CustomTabBarController as the root view
                let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
                window?.rootViewController = CustomTB
                window?.makeKeyAndVisible()
//                window?.rootViewController = UIHostingController(rootView: ProjectView())
                
            } else {

                // user not logged in, take to LoginNavigationController
                let authNC = storyboard.instantiateViewController(identifier: "AuthNC") as! AuthNC
                
                window?.rootViewController = authNC
                window?.makeKeyAndVisible()
            }
        }
        
        
        
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
        
        func setRootViewController(_ vc: UIViewController, _ userId: Int? = nil) {
             if let window = self.window {
                  // if we are logging in, pass the userId
                  if let customTb = vc as? MainTabBarVC {
                       customTb.userId = userId
                  }
                  window.rootViewController = vc
             }
        }
        
}
