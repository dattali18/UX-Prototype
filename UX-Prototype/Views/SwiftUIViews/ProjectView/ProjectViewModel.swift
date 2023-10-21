//
//  ProjectViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/21/23.
//

import Foundation

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    
    init() {
        demoData()
    }
    
    func demoData()  {
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        let project1    = Project(context: managedObjectContext)
        project1.id     = UUID()
        project1.name   = "iOS App Project"
        project1.icon   = "GitHub"
        project1.url    = "https://github.com/dattali18/UX-Prototype"
        project1.descriptions = "This project was inspired by a course in UX/UI design, in which we had to present a prototype of an original app idea. This is the real-life project built from that prototype"
        
        let project2    = Project(context: managedObjectContext)
        project2.id     = UUID()
        project2.name   = "WPF-.NET-Project"
        project2.icon   = "Git"
        project2.url    = "https://github.com/dattali18/WPF-.NET-Project"
        project2.descriptions = "This project is part of the \"mini projects in windows system\" course, focusing on teaching the SOLID principle and basic design patterns such as Singleton and Factory. The project aims to create a store management and selling application using WPF in C#."
        
        self.projects = [project1, project2]
    }
    
    func fetchProject() {
        demoData()
    }
}
