//
//  AssignmentInfoViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/31/23.
//

import Foundation


class AssignmentInfoViewModel : ObservableObject {
    var course: Course?
    var type: String
    
    @Published var assignments: [[Assignment]] = [[], []]
    
    init(course: String, type: String) {
        self.course = CoreDataManager.shared.fetch(entity: Course.self, with: ["name": course])?.first
        self.type = type
        
        fetchData()
    }
    
    /// Fetching data from core data and filtering the right assignment
    func fetchData() {
        var assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        assignments = assignments.filter { $0.course == self.course && $0.type == self.type }

        self.assignments[0] = assignments.filter { $0.done == false }
        self.assignments[1] = assignments.filter { $0.done == true }
    }
}
