//
//  AddProjectViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import Foundation

class AddProjectViewModel : ObservableObject {
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var descriptions: String = ""
    
    @Published var icons: [String] = ["GitHub", "Git"]
    @Published var semesters: [Semester] = []
    @Published var courses: [Course] = []
    
    @Published var selctedIcon: String?
    @Published var selectedSemester: Semester?
    @Published var selectedCourse: Course?
    
    @Published var navigationtitle: String = "Add Project"
    
    var mode: Mode = .add
    
    init(project: Project? = nil) {
        if(project != nil) {
            mode = .edit
            navigationtitle = "Edit Project"
        }
    }
}
