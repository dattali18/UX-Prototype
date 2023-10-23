//
//  CourseViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published var semesters: [Semester] = []
    @Published var selectedSemester: Int = 0
    
    @Published var name: String = ""
    @Published var number: Int32?
    @Published var stringnumber: String = ""
    @Published var credits: Float?
    @Published var hasSemester: Bool = false
    
    @Published var showAlert: Bool = false
    
    @Published var navigationtitle: String = "Add Course"
    
    var course: Course?
    
    var mode: Mode = .add
    

    init(with course: Course? = nil) {
        // Load your semesters data here, e.g., from Core Data
        self.loadSemesters()
        
        
        self.course = course
        
        if(course == nil)
        {
            return
        }
        
        mode = .edit
        navigationtitle = "Edit Course"
        
        let semester = self.course?.semester
        
        if(semester != nil && semesters.isEmpty == false) {
            selectedSemester = semesters.firstIndex(of: semester!) ?? 0
            hasSemester = true
        } else {
            hasSemester = false
        }
        
        name = self.course?.name ?? ""
        number = self.course?.number
        credits = self.course?.credits
    }

    func loadSemesters() {
        // Implement the code to load semesters from Core Data
        // and update the semesters property
        semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
    }
    
    func saveCourse() -> Course?{
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add)
        {
            self.course = Course(context: managedObjectContext)
            course?.id = UUID()
        }
        
        course!.name     = name
        course!.number   = number ?? 0
        course!.credits  = credits ?? 0.0
        
        if (semesters.isEmpty == false) {
            course!.semester = hasSemester ? semesters[selectedSemester] : nil
        }
        
        do {
          try managedObjectContext.save()
          return course
        } catch {
          print("Error creating entity: \(error)")
          return nil
        }
    }
    
    func validateInpute() -> Bool {
        if(name == "" || credits == nil || number == nil)
        {
            return false
        }
        return true
    }
    
    func showingAlert() {
        showAlert = true
    }

}
