//
//  HostingSignUpVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import UIKit
import SwiftUI

class HostingSignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        

        var loginView = SignUpView()
        loginView.loginDelegate = self
        loginView.navigationDelegate = self
        
        let hostingController = UIHostingController(rootView: loginView)
        // Do any additional setup after loading the view.
        
        addChild(hostingController)
    
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}

extension HostingSignUpVC: UserLoginViewDelegate , NavigationViewDelegate{
    func navigate() {
        navigationController?.popViewController(animated: true)
    }
    
    func Login() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(CustomTB)
    }
    
    
}
