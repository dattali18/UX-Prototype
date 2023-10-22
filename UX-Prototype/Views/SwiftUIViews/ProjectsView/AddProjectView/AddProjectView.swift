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
                        Text("Link To Course")
                    })
                    
                    if(viewModel.hasCourse)
                    {
                    
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
            }
            .navigationTitle(viewModel.navigationtitle)
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
                        }
                    } label: {
                        HStack {

                            Text("Save")
                        }
                    }
                    .foregroundColor(.blue)
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
                    }
                }
            }
        }
    }
}

#Preview {
    AddProjectView()
}
