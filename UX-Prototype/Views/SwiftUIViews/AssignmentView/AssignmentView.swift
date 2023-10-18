///
///  SwiftUICustomView.swift
///  UX-Prototype
///
///  Created by Daniel Attali on 10/16/23.
///

import SwiftUI

struct AssignmentView: View {
    weak var delegate: DisappearingViewDelegate?
    
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
                Section("") {
                    Picker("Semester", selection: $viewModel.selectedSemester) {
                        ForEach(0..<viewModel.semesters.count, id: \.self) { index in
                            Text(viewModel.semesters[index].name ?? "")
                        }
                    }
                    
                    if viewModel.courses.indices.contains(viewModel.selectedSemester) {
                        Picker("Course", selection: $viewModel.selectedCourse) {
                            ForEach(0..<viewModel.courses[viewModel.selectedSemester].count, id: \.self) { index in
                                Text(viewModel.courses[viewModel.selectedSemester][index].name ?? "")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assignment")
            .onAppear {
                viewModel.fetchSemestersAndCourses()
                viewModel.editMode()
            }
            .onDisappear {
                self.delegate?.viewWillDisappear()
            }
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        viewModel.saveReminder()
                        // Dismiss the view
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                    }
                    .foregroundColor(.red)
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
