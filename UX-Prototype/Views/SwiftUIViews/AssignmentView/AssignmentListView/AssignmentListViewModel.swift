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
    
    @Published var isPresented: Bool = false
    
    init() {
        let defualt = UserDefaults.standard
        self.selectedOption = defualt.string(forKey: "AssignmentSort")  ?? "All"
        
        fetchData()
    }
    
    var options: [String] = ["All", "Homework", "Midterm", "Final", "Others"]
    var categories: [String] = ["Homework", "Midterm", "Final", "Others"]
    var selectedOption: String = "All"
    
    func fetchData() {
        self.assignments = []
        self.courses = []
        self.sections = []
        
        self.assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        self.assignments = self.assignments.sorted { $0.name ?? "" > $1.name ?? "" }
        
        if self.selectedOption == "All" {
            for category in categories {
                let s = self.assignments.filter { $0.type == category}
                self.sections.append((category, mapAssignmentToCourse(s)))
            }
        } else {
            let s = self.assignments.filter { $0.type == self.selectedOption}
            self.sections.append((self.selectedOption, mapAssignmentToCourse(s)))
        }
    }
    
    func mapAssignmentToCourse(_ assignments: [Assignment]) -> [(String, [Assignment])] {
        let map : [String: [Assignment]] = assignments.reduce(into : [String: [Assignment]]()) { result, assignment in
             let course = assignment.course
             let name = course?.name ?? "General"
             result[name, default: []].append(assignment)
         }
        
        var convertedMap: [(String, [Assignment])] = map.map { (key, value) in
            return (key, value)
        }
        
        convertedMap = convertedMap.sorted { item1, item2 in
            return item1.0 > item2.0
        }
        
        return convertedMap
    }
    
    func addAssignment() {
        self.isPresented = true
    }
    
    func saveUserDefualt() {
        let defualt = UserDefaults.standard
        defualt.set(self.selectedOption, forKey: "AssignmentSort")
    }
}
