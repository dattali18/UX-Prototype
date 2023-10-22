//
//  RemindersVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import SwiftUI

class ProjectsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
//        navigationController?.hidesBarsOnSwipe = true


        var projectView = ProjectsView()
        
        projectView.addProjectDelegate = self
        projectView.delegate = self
        
        let hostingController = UIHostingController(rootView: projectView)
        
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

extension ProjectsVC: AddProjectDelegate, DisappearingViewDelegate {
    func viewWillDisappear() {
            
    }
    
    func pushAddView(project: Project?) {
        
        var addProjectView = AddProjectView(project: project)
        addProjectView.delegate = self
        let hostingController = UIHostingController(rootView: addProjectView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
    
}

