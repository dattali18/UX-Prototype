//
//  AddProjectView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import SwiftUI

struct AddProjectView: View {
    weak var delegate: DisappearingViewDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: AddProjectViewModel
    
    init(project: Project? = nil) {
        _viewModel = StateObject(wrappedValue: AddProjectViewModel(project: project))
    }
    
    var body: some View {
        NavigationView
        {
            Form {
                
                Section {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.descriptions)
                    TextField("URL", text: $viewModel.url)
                } header: {
                    Text("Course Info")
                } footer: {
                    Text("Please enter at least the project's name before saving.")
                }
                
                // Icon Section
                Section("Icon") {
                    Picker("Icon", selection: $viewModel.selectedIcon) {
                        ForEach(0..<viewModel.icons.count, id: \.self) {index in
                            Image(viewModel.icons[index])
                        }
                    }
                }
                    
//              Semester/Course Section
                Section("Course") {
                    Toggle(isOn: $viewModel.hasCourse, label: {
                        HStack {
                            Image(systemName: "books.vertical.circle.fill")
                                .foregroundColor(.pink)
                                .font(.largeTitle)
                            Text("Link To Course")
                        }
                    })
                    .tint(.pink)
                    
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
                        } else if viewModel.selectedSemester == viewModel.semesters.count {
                            Picker("Course", selection: $viewModel.selectedCourse) {
                                ForEach(0..<viewModel.noSemesterCourse.count, id:\.self) { index in
                                    Text(viewModel.noSemesterCourse[index].name ?? "")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.navigationtitle)
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Please enter all info before saving."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        if(viewModel.validateInput())
                        {
                            let _: Project? = viewModel.saveProject()
                            // Dismiss the view
                            self.presentationMode.wrappedValue.dismiss()
                            self.delegate?.viewWillDisappear()
                        } else {
                            self.viewModel.showAlert()
                        }
                    } label: {
                        Text("Save")
                    }
                    .foregroundStyle(.blue)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if(viewModel.mode == .edit)
                    {
                        Button {
                            viewModel.deleteProject()
                            self.presentationMode.wrappedValue.dismiss()
                            self.delegate?.viewWillDisappear()
                        } label : {
                            Text("Delete")
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    AddProjectView()
}
