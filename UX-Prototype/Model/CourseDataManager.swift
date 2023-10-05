//
//  CourseDataManager.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import Foundation
import CoreData

class CourseDataManager {
    static let shared = CourseDataManager()
    
    private init() {}
    
    private var managedObjectContext: NSManagedObjectContext {
        return CoreDataStack.shared.managedObjectContext
    }
    
    // MARK: - CRUD Operations
    
    func deleteCourse(withName name: String?) {
        guard let name = name else { return }
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let matchingCourses = try managedObjectContext.fetch(fetchRequest)
            
            if let courseToDelete = matchingCourses.first {
                managedObjectContext.delete(courseToDelete)
                try managedObjectContext.save()
                print("Course with name '\(name)' deleted successfully.")
            } else {
                print("Course with name '\(name)' not found.")
            }
        } catch {
            print("Error deleting course: \(error.localizedDescription)")
        }
    }
    
    func fetchAllCourses() -> [Course]? {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            let courses = try managedObjectContext.fetch(fetchRequest)
            return courses
        } catch {
            print("Error fetching courses: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchCourse(withName name: String?) -> Course? {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name ?? "")
        
        do {
            let courses = try managedObjectContext.fetch(fetchRequest)
            return courses.first
        } catch {
            print("Error fetching course: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateCourseWithID(_ number: Int32, newName: String, newCredits: Float) -> Course? {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %d", number)
        
        do {
            let courses = try managedObjectContext.fetch(fetchRequest)
            
            if let existingCourse = courses.first {
                existingCourse.name = newName
                existingCourse.credits = newCredits
                
                try managedObjectContext.save()
                
                return existingCourse
            } else {
                print("Course with ID \(number) not found.")
                return nil
            }
        } catch {
            print("Error updating course: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addNewCourse(name: String, number: Int32, credits: Float) -> Bool {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %d", number)
        
        do {
            let existingCourses = try managedObjectContext.fetch(fetchRequest)
            
            if !existingCourses.isEmpty {
                print("Course with ID \(number) already exists.")
                return false
            }
            
            let newCourse = Course(context: managedObjectContext)
            newCourse.name = name
            newCourse.number = number
            newCourse.credits = credits
            
            try managedObjectContext.save()
            
            print("New course added successfully.")
            return true
        } catch {
            print("Error adding course: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Dummy Data
    
    func checkAndAddDummyDataIfNeeded() {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            let existingCourses = try managedObjectContext.fetch(fetchRequest)
            
            if existingCourses.isEmpty {
                addProvidedCourses()
            } else {
                print("Courses already exist.")
            }
        } catch {
            print("Error checking for courses: \(error.localizedDescription)")
        }
    }
    
    private func addSemesters() {
        if(CoreDataManager.shared.fetch(entity: Semester.self) == nil) {
            let start1 = Date()
            let end1 = Date()
            
            let _ = CoreDataManager.shared.create(entity: Semester.self, with: ["type": "Summer", "str": "Summer 2023", "start" : start1, "end": end1])
        }
    }
    
    private func addProvidedCourses() {
        // creating Courses
        addSemesters()
        // Dummy course data provided in separate arrays
        let courseNames = [
            "Linear Algebra I",
            "Linear Algebra II",
            "Intro. To Computers",
            "Preparatory Course in Mathematics for Engineering & Technology",
            "Infinitesimal Calculus 1",
            "Physics for Computer Engineering",
            "Introduction to Computer Science(Lecture+Lab)",
            "Digital Systems"
        ]
        
        let courseNumbers: [Int32] = [
            120201,
            120221,
            150000,
            120000,
            120131,
            141001,
            150005,
            150301
        ]
        
        let courseCredits: [Float] = [
            4.00,
            3.00,
            0.00,
            0.00,
            5.00,
            3.50,
            5.00,
            3.50
        ]
        
        let semester = CoreDataManager.shared.fetch(entity: Semester.self)
        
        for index in 0..<courseNames.count {
            
            let newCourse = Course(context: managedObjectContext)
            newCourse.name = courseNames[index]
            newCourse.number = courseNumbers[index]
            newCourse.credits = courseCredits[index]
            newCourse.semester = semester?.randomElement()
        }
        
        do {
            try managedObjectContext.save()
            print("Dummy data added successfully.")
        } catch {
            print("Error adding dummy data: \(error.localizedDescription)")
        }
    }
}
