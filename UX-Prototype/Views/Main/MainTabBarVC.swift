//
//  MainTabBarVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import SwiftUI

class MainTabBarVC: UITabBarController {
    var userId: Int!
    var projectsNC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        view.backgroundColor = .secondarySystemFill
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        
        let courseNC = storyboard.instantiateViewController(identifier: "CourseNC") as! CourseNC
        let calendarNC = storyboard.instantiateViewController(identifier: "CalendarNC") as! CalendarNC
        let assignmentsNC = storyboard.instantiateViewController(identifier: "AssignmentsNC") as! AssignmentsNC
        let projectsNC = storyboard.instantiateViewController(identifier: "ProjectsNC") as! ProjectsNC
        
        courseNC.tabBarItem.image       = UIImage(systemName: "book.closed")
        calendarNC.tabBarItem.image     = UIImage(systemName: "calendar")
        assignmentsNC.tabBarItem.image  = UIImage(systemName: "pencil.and.ruler.fill")
        projectsNC.tabBarItem.image    = UIImage(systemName: "wrench.and.screwdriver.fill")
        
        courseNC.title = "Courses"
        calendarNC.title = "Calendar"
        assignmentsNC.title = "Assignments"
        projectsNC.title = "Projects"
        
        setViewControllers([courseNC, calendarNC, assignmentsNC, projectsNC], animated: true)
    }
}

extension MainTabBarVC: UITabBarControllerDelegate {
    
}
