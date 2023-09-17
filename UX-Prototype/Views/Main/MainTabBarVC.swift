//
//  MainTabBarVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class MainTabBarVC: UITabBarController {
    var userId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        view.backgroundColor = .systemRed
//        view.tintColor = .systemRed

        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        
        let courseNC = storyboard.instantiateViewController(identifier: "CourseNC") as! CourseNC
        let calendarNC = storyboard.instantiateViewController(identifier: "CalendarNC") as! CalendarNC
        let AssignmentsNC = storyboard.instantiateViewController(identifier: "AssignmentsNC") as! AssignmentsNC
        let remindersNC = storyboard.instantiateViewController(identifier: "RemindersNC") as! RemindersNC
        
        courseNC.tabBarItem.image       = UIImage(systemName: "book.closed")
        calendarNC.tabBarItem.image     = UIImage(systemName: "calendar")
        AssignmentsNC.tabBarItem.image  = UIImage(systemName: "clock.arrow.circlepath")
        remindersNC.tabBarItem.image    = UIImage(systemName: "square.and.pencil")
        
        courseNC.title = "Courses"
        calendarNC.title = "Calendar"
        AssignmentsNC.title = "Assignments"
        remindersNC.title = "Reminders"
       
       
        tabBar.tintColor = .systemBlue
        
        setViewControllers([courseNC, calendarNC, AssignmentsNC, remindersNC], animated: true)
    }
    


}

extension MainTabBarVC: UITabBarControllerDelegate {
    
}
