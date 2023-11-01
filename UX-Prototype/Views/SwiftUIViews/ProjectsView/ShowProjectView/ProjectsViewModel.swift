//
//  ProjectViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/21/23.
//

import Foundation

class ProjectsViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var selectedProject: Project?
    
    @Published var deleteAlertShowing: Bool = false
    
    @Published var isPresented: Bool = false
    var action: ProjectsActionType = .add
    var project: Project?
    
    init() {
        fetchProject()
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
        
        do {
            try managedObjectContext.save()
            
        } catch {
            print("Error creating/updating entity: \(error)")
        }
    }
    
    func fetchProject() {
        self.projects = CoreDataManager.shared.fetch(entity: Project.self) ?? []
    }
    
    func deleteProject(project: Project?) {
        self.projects.removeAll(where: { $0 == project })
        CoreDataManager.shared.delete(project)
    }
    
    func showDeleteAlert() {
        deleteAlertShowing = true
    }
    
    func editProject(_ project: Project)  {
        self.isPresented = true
        self.action = .edit
        self.project = project
        
    }
    
    func addProject() {
        self.isPresented = true
        self.action = .add
    }
}

enum ProjectsActionType {
    case add
    case edit
}
