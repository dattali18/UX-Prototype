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
    @Published var sections: [(String,[(String, [Assignment])])] = []
    
    init() {
        fetchData()
    }
    
    var options: [String] = ["All", "Homework", "Midterm", "Final", "Others"]
    var selectedOption: String = "All"
    
    func fetchData() {
        self.assignments = []
        self.courses = []
        
        self.assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        
        for option in options {
            let s = self.assignments.filter { $0.type == option}
            self.sections.append((option, mapAssignmentToCourse(s)))
        }
        
    }
    
    func mapAssignmentToCourse(_ assignments: [Assignment]) -> [(String, [Assignment])] {
        let map : [String: [Assignment]] = assignments.reduce(into : [String: [Assignment]]()) { result, assignment in
             let course = assignment.course
             let name = course?.name ?? "General"
             result[name, default: []].append(assignment)
         }
        
        let convertedMap: [(String, [Assignment])] = map.map { (key, value) in
            return (key, value)
        }
        
        return convertedMap
    }
}
