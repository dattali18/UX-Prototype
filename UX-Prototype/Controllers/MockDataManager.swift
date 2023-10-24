//
//  MockDataManager.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/24/23.
//

import Foundation
import CoreData

class MockDataManager {
    static let shared = MockDataManager()
    
    private init() {}
    
    private var managedObjectContext: NSManagedObjectContext {
        return CoreDataStack.shared.managedObjectContext
    }
    
    func CreateMockData() {
        CreateCourseData()
        CreateResourceData()
        CreateProjectData()
        CreateAssignmentData()
    }
    
    func CreateCourseData() {
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        if(!courses.isEmpty) {
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let semester = Semester(context: managedObjectContext)
        semester.id = UUID()
        semester.name = "Fall 2023"
        semester.type = "Fall"
        semester.start = formatter.date(from: "2023/11/08")
        semester.end = formatter.date(from: "2024/3/08")
        
        let names: [String] = ["SQL", "Software Engineering", "Windows Development", "Intro to reversing", "Data mining", "AI & ML"]
        let numbes: [Int32] = [150221, 151060, 153004, 157130, 157123, 157102]
        let credits: [Float] = [3.00, 5.00, 2.00, 4.00, 4.00, 3.00]
        
        for index in 0..<names.count {
            let course = Course(context: managedObjectContext)
            course.id = UUID()
            course.name = names[index]
            course.number = numbes[index]
            course.credits = credits[index]
            course.semester = semester
        }
        
        do {
            try managedObjectContext.save()
            print("Dummy data added successfully.")
        } catch {
            print("Error adding dummy data: \(error.localizedDescription)")
        }
    }
    
    func CreateResourceData() {
        let resources = CoreDataManager.shared.fetch(entity: Resource.self) ?? []
        if(!resources.isEmpty) {
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        
        if(courses.isEmpty) {
            return
        }
        

        let resourceNames = ["YouTube", "Google Drive", "WhatsApp", "Contact Info", "Assignment Guidelines", "Discussion Forum"]
        let linkNames = ["Course YouTube Link", "Course Moodle", "Ms Israel Israeli", "John Doe", "Alice Smith", "Course Syllabus", "Contact Support", "Assignment Submission", "Announcements", "Discussion Board"]
        let linkURLs = [
            "https://www.youtube.com/watch?v=ZOh08w9Ku9k",
            "https://moodle.jct.ac.il/course/view.php?id=62761",
            "tel:555555555",
            "mailto:john.doe@example.com",
            "mailto:alice.smith@example.com",
            "https://example.com/syllabus",
            "mailto:support@example.com",
            "https://example.com/submit-assignment",
            "https://example.com/announcements",
            "https://example.com/discussion-board",
            "tel:123456789",
            "tel:987654321",
            "mailto:professor@example.com",
            "mailto:tutor@example.com",
            "https://example.com/lecture-notes",
            "https://example.com/quizzes",
            "https://example.com/resource-center"
        ]

        for course in courses {
            for _ in 1...Int.random(in: 1...4) {
                var links: [Link] = []
                let resource = Resource(context: managedObjectContext)
                resource.id = UUID()
                resource.name = resourceNames.randomElement()
                
                // Create 2 random links for each resource
                links = []
                for _ in 1...Int.random(in: 1...3) {
                    let link = Link(context: managedObjectContext)
                    link.id = UUID()
                    link.name = linkNames.randomElement()
                    link.url = linkURLs.randomElement()
                    links.append(link)
                }
                
                resource.links = NSSet(array: links)
                course.addToResources(resource)
            }
        }

        
//        for course in courses {
//            let name = ["YouTube", "Moodle", "Contact Info"]
//            
//            let youtube = Link(context: managedObjectContext)
//            youtube.id = UUID()
//            youtube.name = "Course YouTube Link"
//            youtube.url = "https://www.youtube.com/watch?v=ZOh08w9Ku9k"
//
//            let moodle = Link(context: managedObjectContext)
//            moodle.id = UUID()
//            moodle.name = "Course Moddle"
//            moodle.url = "https://moodle.jct.ac.il/course/view.php?id=62761"
//            
//            let contactinfo = Link(context: managedObjectContext)
//            contactinfo.id = UUID()
//            contactinfo.name = "Ms Israel Israeli"
//            contactinfo.url = "555555555"
//            
//            let links: [Link] = [youtube, moodle , contactinfo]
//            
//            let resource1 = Resource(context: managedObjectContext)
//            resource1.id = UUID()
//            resource1.name = name.randomElement()
//            resource1.links = NSSet(array: links)
//            
//            let resource2 = Resource(context: managedObjectContext)
//            resource2.id = UUID()
//            resource2.name = name.randomElement()
//            resource2.links = NSSet(array: links)
//            
//            course.resources = NSSet(array: [resource1, resource2])
//        }
        
        do {
            try managedObjectContext.save()
            print("Dummy data added successfully.")
        } catch {
            print("Error adding dummy data: \(error.localizedDescription)")
        }
    }
    
    func CreateProjectData() {
        let projects = CoreDataManager.shared.fetch(entity: Project.self) ?? []
        if(!projects.isEmpty) {
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        let iosProject = Project(context: managedObjectContext)
        
        iosProject.id = UUID()
        iosProject.name = "iOS App"
        iosProject.descriptions = "his project was inspired by a course in UX/UI design, in which we had to present a prototype of an original app idea. This is the real-life project built from that prototype"
        iosProject.url = "https://github.com/dattali18/UX-Prototype"
        iosProject.icon = "Git"
        
        let dotNetProject = Project(context: managedObjectContext)
        dotNetProject.id = UUID()
        dotNetProject.name = ".Net Project"
        dotNetProject.descriptions = "This is a repo for the MiniProjectInWindows In here we are going to build a GUI application with fronend and backend for a store"
        dotNetProject.url = "https://github.com/dattali18/dotNet5783_0879_5987"
        dotNetProject.icon = "Git"
        
        do {
            try managedObjectContext.save()
            print("Dummy data added successfully.")
        } catch {
            print("Error adding dummy data: \(error.localizedDescription)")
        }
        
    }
    
    func CreateAssignmentData() {
        let assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        if(!assignments.isEmpty) {
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        // No assignments exist, so let's add some sample assignments
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []

        let sampleDescriptions = [
            "Complete homework assignment",
            "Prepare for midterm exam",
            "Submit final project",
            "Read chapters 3 and 4",
            "Solve practice problems",
            "Write a research paper",
            "Review class notes",
            "Create a presentation"
        ]
        
        let sampleNames = [
            "Homework",
            "Midterm Exam Preparation",
            "Final Project Submission",
            "Reading Assignment",
            "Practice Problems",
            "Research Paper",
            "Class Notes Review",
            "Presentation Creation"
        ]
        

        let today = Date()

        for course in courses {
            // Add sample Homework assignment with a random check
            for _ in 0...Int.random(in: 0...3) {
                let random = Int.random(in: 1...5)
                let index = Int.random(in: 0..<sampleNames.count)
                
                let assignment = Assignment(context: managedObjectContext)
                assignment.id = UUID()
                
                
                assignment.name = sampleNames[index]
                assignment.descriptions = sampleDescriptions[index]
                assignment.due = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...30), to: today) // Due in 1-30 days
                assignment.course = course
                
                switch random {
                case 1:
                    assignment.type = "Homework"
                case 2:
                    assignment.type = "Midterm"
                case 3:
                    assignment.type = "Final"
                case 4:
                    assignment.type = "Others"
                default:
                    continue
                }
            }
        }
            
        
        do {
            try managedObjectContext.save()
            print("Dummy data added successfully.")
        } catch {
            print("Error adding dummy data: \(error.localizedDescription)")
        }
    }
}
