//
//  SwiftUICustomView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/16/23.
//

import SwiftUI

struct AssignmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: AssignmentViewModel

    init(with assignment: Assignment? = nil) {
        _viewModel = StateObject(wrappedValue: AssignmentViewModel(with: assignment))
    }
    
    var body: some View {
        NavigationView
        {
            Form {
                // Text Info Section
                Section("") {
                    TextField("Title", text: $viewModel.title)
                    TextField("Notes", text: $viewModel.notes)
                    TextField("URL", text: $viewModel.url)
                }
                
                // Date Section
                Section("") {
                    Toggle(isOn: $viewModel.dateTime, label: {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("Date")
                    }
                })
                    .tint(.red)
                
                    if viewModel.dateTime {
                        DatePicker("Due Date", selection: $viewModel.dueDate)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                    }
                }
                
                // Type Section
                Section("") {
                    HStack
                    {
                        Image(systemName: "graduationcap.circle.fill")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                        Picker("Type", selection: $viewModel.selectedType) {
                            ForEach(0..<viewModel.types.count, id: \.self) {index in
                                Text(viewModel.types[index])
                            }
                        }
                    }
                }
                
                // Semester/Course Section
//                Section("Course") {
//                    Toggle(isOn: $viewModel.hasCourse, label: {
//                        Text("Link To Course")
//                    })
//                    
//                    if (viewModel.hasCourse) {
//                        
//                        Picker("Semester", selection: $viewModel.selectedSemester) {
//                            ForEach(0..<viewModel.semesters.count + 1, id: \.self) { index in
//                                if(index < viewModel.semesters.count) {
//                                    Text(viewModel.semesters[index].name ?? "")
//                                } else {
//                                    Text("No Semester")
//                                }
//                            }
//                        }
//                        
//                        if viewModel.courses.indices.contains(viewModel.selectedSemester) {
//                            Picker("Course", selection: $viewModel.selectedCourse) {
//                                ForEach(0..<viewModel.courses[viewModel.selectedSemester].count, id: \.self) { index in
//                                    Text(viewModel.courses[viewModel.selectedSemester][index].name ?? "")
//                                }
//                            }
//                        } else if viewModel.selectedSemester == viewModel.semesters.count {
//                            Picker("Course", selection: $viewModel.selectedCourse) {
//                                ForEach(0..<viewModel.noSemesterCourse.count, id:\.self) { index in
//                                    Text(viewModel.noSemesterCourse[index].name ?? "")
//                                }
//                            }
//                        }
//                    }
//                }
                Section("Course") {
                    Toggle(isOn: $viewModel.hasCourse, label: {
                        HStack {
                            Image(systemName: "books.vertical.circle.fill")
                                .foregroundColor(.yellow)
                                .font(.largeTitle)
                            Text("Link To Course")
                        }
                    })
                    .tint(.yellow)
                    
                    if(viewModel.hasCourse) {
                    
                        Picker("Semester", selection: $viewModel.selectedSemester) {
                            ForEach(0..<viewModel.semesters.count + 1, id: \.self) { index in
                                if(index < viewModel.semesters.count) {
                                    Text(viewModel.semesters[index].name ?? "")
                                } else {
                                    Text("No Semester")
                                }
                            }
                        }
                        
                        if viewModel.courses.indices.contains(viewModel.selectedSemester) {
                            Picker("Course", selection: $viewModel.selectedCourse) {
                                ForEach(0..<viewModel.courses[viewModel.selectedSemester].count, id: \.self) { index in
                                    Text(viewModel.courses[viewModel.selectedSemester][index].name ?? "")
                                }
                            }
                        }
                       else if viewModel.selectedSemester == viewModel.semesters.count {
                            Picker("Course", selection: $viewModel.selectedCourse) {
                                ForEach(0..<viewModel.noSemesterCourses.count, id:\.self) { index in
                                    Text(viewModel.noSemesterCourses[index].name ?? "")
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Toggle(isOn: $viewModel.createReminder) {
                        HStack {
                            Image(systemName: "list.bullet.circle.fill")
                                .foregroundColor(.pink)
                                .font(.largeTitle)
                            Text("Create Reminder")
                        }
                    }.tint(.pink)
                } header : {
                    Text("Reminder")
                } footer : {
                    Text("If you wan't to create a reminder.")
                }
                
                
                Section {
                    Toggle(isOn: $viewModel.createEvent, label: {
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                                .foregroundColor(.green)
                                .font(.largeTitle)
                            Text("Create Event")
                        }
                    }).tint(.green)
                           
               } header : {
                   Text("Events")
               } footer : {
                   Text("If you want to crate a calendar event.")
               }
            }
            .navigationTitle(viewModel.navigationtitle)
            .onAppear {
                viewModel.fetchSemestersAndCourses()
                viewModel.editMode()
            }
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        if(viewModel.validateInput())
                        {
                            let _ : Assignment? = viewModel.saveReminder()
                            // Dismiss the view
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        HStack {
//                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
        }
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
