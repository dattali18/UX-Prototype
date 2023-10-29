//
//  CourseListVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/29/23.
//

import UIKit
import SwiftUI

class CourseListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        let courseView = CoursesListView()
        
        let hostingController = UIHostingController(rootView: courseView)
        
        let vcView = hostingController.view!
        
        vcView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(vcView)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    
}
