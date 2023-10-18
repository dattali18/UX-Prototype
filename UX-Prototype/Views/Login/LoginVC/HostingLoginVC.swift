//
//  HostingVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import UIKit
import SwiftUI

class HostingLoginVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground

        var loginView = SignInView()
        loginView.loginDelegate = self
        loginView.navigationDelegate = self
        
        let hostingController = UIHostingController(rootView: loginView)
        
        addChild(hostingController)
    
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}

extension HostingLoginVC: UserLoginViewDelegate , NavigationViewDelegate{
    func navigate() {
        let vc = HostingSignUpVC()
        
        navigationController?.pushViewController( vc, animated: true)
    }
    
    func Login() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(CustomTB)
        
    }
    
    
}
