//
//  SemesterInfoViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import Foundation

/// SemesterInfoViewModel class is the view model for the SemesterInfoView view
class SemesterInfoViewModel : ObservableObject {
    static var semester = CoreDataManager.shared.fetch(entity: Semester.self)?.first
    
    /// The semester obj that info will be shown
    var semester: Semester?
    
    var name: String = ""
    var startDate: String = ""
    var endDate: String = ""
    
    var totalCredits: Float = 0.0
    var totalCourses: Int = 0
    
    var avg: Float = 0.0
    
    var courses: [Course] = []
    
    /// init the view model
    /// - Parameter semester: a semester obj to be shown
    init(semester: Semester?) {
        self.semester = semester
        
        if self.semester != nil {
            name = self.semester!.name ?? "None"
            
            // Create Date Formatter
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "dd/MM/YYYY"

            // Convert Date to String
            
            
            startDate = dateFormatter.string(from: self.semester?.start ?? Date())
            endDate = dateFormatter.string(from: self.semester?.end ?? Date())
            
            
            courses = self.semester?.courses?.allObjects as! [Course]
            
            totalCourses = courses.count
            
            for course in courses {
                totalCredits += course.credits
            }
            
            avg = calcAvg()
        }
    }
    
    func calcAvg() -> Float {
        var total: Float = 0
        
        for course in courses {
            total += course.credits + course.grade
        }
        return total / Float(totalCourses)
    }
}
