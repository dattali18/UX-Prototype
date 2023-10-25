//
//  CourseListViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import Foundation

class CoursesListViewModel : ObservableObject {
    
    @Published var courses : [[Course]] = []
    @Published var semesters : [Semester] = []
    
    @Published var sectionsName : [String] = []
    @Published var sectionCount : Int = 0
    
    @Published var options: [String] = []
    @Published var selectedOption: String = "All"
    
    var noSemester: String = "Course Without Semester"
    
    init() {
        fetchData()
    }
    
    // MARK: - DATA FETCHING

    
    ///  fetching the data from the core data and putting it into the different lists
    func fetchData() {
        /// fetching and sorting all courses
        var allCoureses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        allCoureses = allCoureses.sorted { $0.name ?? "" > $1.name ?? "" }
        
        /// fetching and sorrting all semesters
        semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
        semesters = semesters.sorted { $0.start ?? Date() > $1.start ?? Date() }
        
        /// maping courses to semesters
        for semester in semesters {
            self.courses.append(allCoureses.filter { $0.semester == semester })
            self.sectionsName.append(semester.name ?? "")
        }
        
        /// adding courses without semesters
        self.courses.append(allCoureses.filter { $0.semester == nil })
        self.sectionsName.append(noSemester)
        
        self.sectionCount = self.sectionsName.count
        
        /// setting up the option for filtering
        self.options = self.sectionsName
        self.options.insert("All", at: 0)
    }
    
    /// get the semester with name == name
    /// - Parameter name: the name of the semester
    /// - Returns: either the semester of nil if there is no semster with name == name
    func getSemesterByName(name: String) -> Semester? {
        if(name == noSemester) {
            return nil
        }
        
        return self.semesters.first(where: { $0.name == name })
    }
    
    func editSemester(name: String) {
        let semester = self.getSemesterByName(name: name)
        if(semester == nil) {
            return
        }
        
    }
}

