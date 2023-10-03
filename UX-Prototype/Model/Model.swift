//
//  Model.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/3/23.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Replace with your model name
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}

func deleteCourse(withName name: String?) {
    let managedObjectContext = CoreDataStack.shared.managedObjectContext

    // Create a fetch request for the Course entity
    let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
    
    // Set a predicate to filter courses by name
    fetchRequest.predicate = NSPredicate(format: "name == %@", name!)
    
    do {
        // Fetch the courses that match the predicate
        let matchingCourses = try managedObjectContext.fetch(fetchRequest)
        
        if let courseToDelete = matchingCourses.first {
            // Delete the course
            managedObjectContext.delete(courseToDelete)
            
            // Save the changes
            try managedObjectContext.save()
            
            print("Course with name '\(name ?? "None")' deleted successfully.")
        } else {
            print("Course with name '\(name ?? "None")' not found.")
        }
    } catch {
        print("Error deleting course: \(error.localizedDescription)")
    }
}


func fetchAllCourses() -> [Course]? {
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    // Create a fetch request for the Course entity
    let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
    
    do {
        // Fetch all courses
        let courses = try managedObjectContext.fetch(fetchRequest)
        return courses
    } catch {
        print("Error fetching courses: \(error.localizedDescription)")
        return nil
    }
}


func updateCourseWithID(_ number: Int16, newName: String, newCredits: Float) -> Course? {
    let managedObjectContext = CoreDataStack.shared.managedObjectContext

    // Create a fetch request with a predicate to filter by ID
    let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "number == %d", number)

    do {
        // Fetch the course using the ID predicate
        let courses = try managedObjectContext.fetch(fetchRequest)

        if let existingCourse = courses.first {
            // Update mutable properties
            existingCourse.name = newName
            existingCourse.credits = newCredits

            // Save the changes
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
    let managedObjectContext = CoreDataStack.shared.managedObjectContext

    // Check if a course with the given number (ID) already exists
    let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "number == %d", number)

    do {
        let existingCourses = try managedObjectContext.fetch(fetchRequest)
        
        // If a course with the same number (ID) already exists, return false
        if !existingCourses.isEmpty {
            print("Course with ID \(number) already exists.")
            return false
        }
        
        // If no course with the same number (ID) exists, create a new course
        let newCourse = Course(context: managedObjectContext)
        newCourse.name = name
        newCourse.number = number
        newCourse.credits = credits
        
        // Save the new course
        try managedObjectContext.save()
        
        print("New course added successfully.")
        return true
    } catch {
        print("Error adding course: \(error.localizedDescription)")
        return false
    }
}


func checkAndAddDummyDataIfNeeded() {
    let managedObjectContext = CoreDataStack.shared.managedObjectContext

    // Create a fetch request to check if there are any courses
    let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()

    do {
        let existingCourses = try managedObjectContext.fetch(fetchRequest)

        if existingCourses.isEmpty {
            // There are no courses, so add the provided data as dummy courses
            addProvidedCourses()
        } else {
            // Courses already exist
            print("Courses already exist.")
        }
    } catch {
        print("Error checking for courses: \(error.localizedDescription)")
    }
}

func addProvidedCourses() {
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
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

    let courseNumbers : [Int32] = [
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

    for index in 0..<courseNames.count {
        let newCourse = Course(context: managedObjectContext)
        newCourse.name = courseNames[index]
        newCourse.number = courseNumbers[index]
        newCourse.credits = courseCredits[index]
    }

    // Save the dummy data
    do {
        try managedObjectContext.save()
        print("Dummy data added successfully.")
    } catch {
        print("Error adding dummy data: \(error.localizedDescription)")
    }
}
