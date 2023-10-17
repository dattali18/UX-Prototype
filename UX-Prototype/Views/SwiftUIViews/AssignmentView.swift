//
//  SwiftUICustomView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/16/23.
//

import SwiftUI

struct AssignmentView: View {
    weak var delegate: DisappearingViewDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var url: String = ""
    @State private var type: String = ""
    @State private var dueDate: Date = Date.now
    
    @State private var datetime: Bool = false
    
    @State private var importance: Int32 = 1
    
    @State private var selectedSemester: Int = 0
    @State private var selectedCourse: Int = 0
    
    @State private var selectedType: Int = 0
    
    
    
    @State private var semesters: [Semester] = []
    @State private var courses: [[Course]] = []
    
    @State private var types: [String] = ["Homework", "Midterm", "Final", "Others"]
    
    @State private var assignment: Assignment?

    init(assignment: Assignment? = nil) {
        self._assignment = State(initialValue: assignment)
    }
    
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
            .navigationTitle("New Assignment")
            .onAppear {
                fetchSemestersAndCourses()
                if let assignment = assignment {
                    // Populate the fields with assignment data
                    title = assignment.name ?? ""
                    notes = assignment.descriptions ?? ""
                    url = assignment.url ?? ""
                    dueDate = assignment.due ?? Date.now
                    datetime = assignment.due != nil
                    selectedType = types.firstIndex(where: { $0 == assignment.type ?? "Homework" }) ?? 0
                    selectedSemester = semesters.firstIndex(where: {$0 == assignment.course?.semester}) ?? 0
                    selectedCourse = courses[selectedSemester].firstIndex(where: {$0 == assignment.course}) ?? 0
                    // You can also set selectedSemester and selectedCourse
                }
            }.onDisappear {
                self.delegate?.viewWillDisappear()
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
        if title.isEmpty {
            return
        }

        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if let assignment = assignment {
            // Update the existing assignment
            assignment.name = title
            assignment.descriptions = notes
            assignment.due = dueDate
            assignment.url = url
            assignment.type = types[selectedType]
            assignment.course = self.courses[selectedSemester][selectedCourse]
            
        } else {
            // Create a new assignment
            let assignment = Assignment(context: managedObjectContext)
            assignment.name = title
            assignment.descriptions = notes
            assignment.due = dueDate
            assignment.type = types[selectedType]
            assignment.course = self.courses[selectedSemester][selectedCourse]
            
            // Add the assignment to the course
            let course = self.courses[selectedSemester][selectedCourse]
            course.addToAssignments(assignment)
            
            // Insert the assignment into the context
            managedObjectContext.insert(assignment)
        }
        
        do {
            try managedObjectContext.save()
            
            // Dismiss the view
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error creating/updating entity: \(error)")
        }
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
    AssignmentView()
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
