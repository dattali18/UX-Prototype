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
    
    @Published var showingDeleteAlert: Bool = false
    @Published var isPresented: Bool = false
    var index: Int?
    var assignment: Assignment?
    
    
    init(course: String, type: String) {
        self.course = CoreDataManager.shared.fetch(entity: Course.self, with: ["name": course])?.first
        self.type = type
        
        fetchData()
    }
    
    /// Fetching data from core data and filtering the right assignment
    func fetchData() {
        self.assignments = [[], []]
        
        var assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        assignments = assignments.filter { $0.course == self.course && $0.type == self.type }

        self.assignments[0] = assignments.filter { $0.done == false }
        self.assignments[1] = assignments.filter { $0.done == true }
    }
    
    func showDeleteAlert(_ assignment: Assignment, _ index: Int) {
        self.assignment = assignment
        self.index = index
        self.showingDeleteAlert = true
    }
    
    func deleteAssignment() {
        self.assignments[self.index!].removeAll(where: { $0 ==  self.assignment! })
        CoreDataManager.shared.delete(assignment)
    }
    
    func dateFormatter(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "E d MMM"
        
        // Convert the Date to a String
        return dateFormatter.string(from: date)
    }
    
    func editAssignment(assignment: Assignment) {
        self.assignment = assignment
        
        self.isPresented = true
    }
}
