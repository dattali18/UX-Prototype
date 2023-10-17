//
//  SwiftUICustomView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/16/23.
//

import SwiftUI

struct SwiftUICustomView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = "New Reminder"
    @State private var notes: String = ""
    @State private var url: String = ""
    @State private var type: String = ""
    @State private var dueDate: Date = Date.now
    
    @State private var datetime: Bool = false
    
    @State private var improtance: Int32 = 1
    
    @State private var selectedSemester: Int = 0
    @State private var selectedCourse: Int = 0
    
    @State private var selectedType: Int = 0
    
    
    
    @State private var semesters: [Semester] = []
    @State private var courses: [[Course]] = []
    
    @State private var types: [String] = ["Homework", "Midterm", "Final"]
    
    var body: some View {
        NavigationView
        {
            Form {
                Section() {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes)
                    TextField("URL", text: $url)
                }
                
                Section()
                {
                    Toggle(isOn: $datetime, label: {
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                            Text("Date")
                        }
                    })
                    
                    if datetime {
                        DatePicker("Due Date", selection: $dueDate)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                    }
                }
                
                Section()
                {
                    HStack
                    {
                        Image(systemName: "graduationcap.circle.fill")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                        Picker("Type", selection: $selectedType) {
                            ForEach(0..<types.count, id: \.self) {index in
                                Text(types[index])
                            }
                        }
                    }
                }
                
                Section()
                {
                    HStack
                    {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange)
                            .font(.largeTitle)
                        Picker("Improtance", selection: $improtance) {
                            ForEach(1..<4, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                    }
                }
                
                Section() {
                    Picker("Semester", selection: $selectedSemester) {
                        ForEach(0..<semesters.count, id: \.self) { index in
                            Text(semesters[index].str ?? "")
                        }
                    }
                    
                    if courses.indices.contains(selectedSemester) {
                        Picker("Course", selection: $selectedCourse) {
                            ForEach(0..<courses[selectedSemester].count, id: \.self) { index in
                                Text(courses[selectedSemester][index].name ?? "")
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Reminder")
            .onAppear {
                fetchSemestersAndCourses()
            }
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Handle the save action here
                        saveReminder()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    func saveReminder() {
        if(title != "")
        {
            let managedObjectContext = CoreDataStack.shared.managedObjectContext
            
            let assignment = Assignment(context: managedObjectContext)
            let course = self.courses[selectedSemester][selectedCourse]
            
            assignment.name = title
            assignment.descriptions = notes
            assignment.due = dueDate
            assignment.importance = improtance
            assignment.type = types[selectedType]
            assignment.course = self.courses[selectedSemester][selectedCourse]
            
            course.addToAssignments(assignment)
            
            managedObjectContext.insert(assignment)
            
            
            
            do {
              try managedObjectContext.save()
            } catch {
              print("Error creating entity: \(error)")
              return
            }
            
            // Dismiss the view
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func saveReminder() {
            // Implement the logic to save the reminder
            // You can access reminder properties like reminder?.title, reminder?.notes, etc.
            // Here, you can update your data model or use Core Data to save the reminder.
            // This function should handle the saving logic according to your app's requirements.
        let _ = CoreDataManager.shared.create(entity: Assignment.self, with: [
            "name" : title,
            "descriptions": notes,
            "due": datetime ? dueDate : Date(),
            "importance": improtance,
            "type": type,
            "course" : courses[selectedSemester][selectedCourse]
        ])
    }
    
    private func fetchSemestersAndCourses() {
        let semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
        self.semesters = semesters

        // Fetch all courses
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []

        // Group courses by their associated semester
        var courseGroups: [[Course]] = Array(repeating: [], count: semesters.count)
        for course in courses {
            if let semester = course.semester, let index = semesters.firstIndex(of: semester) {
                courseGroups[index].append(course)
            }
        }
        self.courses = courseGroups
    }
}

#Preview {
    SwiftUICustomView()
}
