//
//  SwiftUICustomView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/16/23.
//

import SwiftUI

struct SwiftUICustomView: View {
    @State private var title: String = "New Reminder"
    @State private var notes: String = ""
    @State private var url: String = ""
    @State private var dueDate = Date.now
    
    @State private var datetime = false
    
    @State private var improtance = 1
    
    @State private var selectedSemester: Int = 0
    @State private var selectedCourse: Int = 0
    
    
    @State private var semesters: [Semester] = []
    @State private var courses: [[Course]] = []
    
    var body: some View {
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
                Picker("Improtance", selection: $improtance) {
                    ForEach(1..<4) {
                        Text("\($0)")
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
        }.onAppear {
            fetchSemestersAndCourses()
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
    SwiftUICustomView()
}
