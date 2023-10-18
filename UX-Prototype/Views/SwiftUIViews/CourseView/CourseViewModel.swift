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
    @Published var number: Int?
    @Published var credits: Float?
    @Published var haveSemester: Bool = true
    

    init() {
        // Load your semesters data here, e.g., from Core Data
        self.loadSemesters()
    }

    func loadSemesters() {
        // Implement the code to load semesters from Core Data
        // and update the semesters property
        semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
    }
    
    func saveCourse() {
        print("hi")
    }
}
