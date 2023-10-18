//
//  AssignmentViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import Foundation

class AssignmentViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var notes: String = ""
    @Published var url: String = ""
    @Published var type: String = ""
    @Published var dueDate: Date = Date.now
    @Published var dateTime: Bool = false
    
    @Published var selectedSemester: Int = 0
    @Published var selectedCourse: Int = 0
    @Published var selectedType: Int = 0
    
    @Published var semesters: [Semester] = []
    @Published var courses: [[Course]] = []
    @Published var types: [String] = ["Homework", "Midterm", "Final", "Others"]
    
    var assignment: Assignment?
    
    init(with assignment: Assignment? = nil) {
        self.assignment = assignment
    }
    
    
    func editMode() {
        if(assignment != nil) {
            // Populate the fields with assignment data
            title = assignment!.name ?? ""
            notes = assignment!.descriptions ?? ""
            url = assignment!.url ?? ""
            dueDate = assignment!.due ?? Date.now
            dateTime = assignment!.due != nil
            selectedType = types.firstIndex(where: { $0 == assignment!.type ?? "Homework" }) ?? 0
            selectedSemester = semesters.firstIndex(where: {$0 == assignment!.course?.semester}) ?? 0
            selectedCourse = courses[selectedSemester].firstIndex(where: {$0 == assignment!.course}) ?? 0
        }
    }
    
    func saveReminder() {
        if title.isEmpty {
            return
        }

        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if let assignment = assignment {
            // Update the existing assignment
            assignment.name = title
            assignment.descriptions = notes
            assignment.due = dateTime ? dueDate : nil
            assignment.url = url
            assignment.type = types[selectedType]
            assignment.course = self.courses[selectedSemester][selectedCourse]
            
        } else {
            // Create a new assignment
            let assignment = Assignment(context: managedObjectContext)
            assignment.name = title
            assignment.descriptions = notes
            assignment.due = dateTime ? dueDate : nil
            assignment.type = types[selectedType]
            assignment.course = self.courses[selectedSemester][selectedCourse]
            
            // Add the assignment to the course
            let course = self.courses[selectedSemester][selectedCourse]
            course.addToAssignments(assignment)
            
            // Insert the assignment into the context
            managedObjectContext.insert(assignment)
        }
        
        do {
            try managedObjectContext.save()
            
        } catch {
            print("Error creating/updating entity: \(error)")
        }
    }
    
    func fetchSemestersAndCourses() {
        let semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
        self.semesters = semesters

        // Fetch all courses
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []

        // Group courses by their associated semester
        var courseGroups: [[Course]] = Array(repeating: [], count: semesters.count)
        for course in courses {
            if let semester = course.semester, let index = semesters.firstIndex(of: semester) {
                courseGroups[index].append(course)
            }
        }
        self.courses = courseGroups
    }
}


