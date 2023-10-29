//
//  AssignmentListViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/29/23.
//

import Foundation


class AssignmentListViewModel : ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var courses: [Course] = []
    @Published var sections: [[String: [Assignment]]] = []
    
    var options: [String] = ["All", "Homework", "Midterm", "Final", "Others"]
    var selectedOption: String = "All"
    
    func fetchData() {
        self.assignments = []
        self.courses = []
        
        self.assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        
        for option in options {
            sections.append(sortAssignmentsByCourse(self.assignments.filter { $0.type == option}))
        }
    }
    
    func sortAssignmentsByCourse(_ assignments: [Assignment]) -> [String: [Assignment]] {
        var map : [String: [Assignment]] = assignments.reduce(into : [String: [Assignment]]()) { result, assignment in
            let course = assignment.course
            let name = course?.name ?? "General"
            result[name, default: []].append(assignment)
        }
        
        return map.filter { !$0.value.isEmpty }
    }
    
}
