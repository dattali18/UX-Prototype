//
//  CourseInfoView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct CourseInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CourseInfoViewModel
    
    init(course: Course?) {
        self._viewModel = StateObject(wrappedValue: CourseInfoViewModel(course: course))
    }
    
    var body: some View {
        Form {
            Section("Course Info") {
                Text("Name")
                    .badge(Text(viewModel.course?.name ?? "None"))
                    
                
                Text("Number")
                    .badge(Text(String(viewModel.course?.number ?? 0)))
                
                Text("Credits")
                    .badge(Text(String(viewModel.course?.credits ?? 0.0)))
            }
            
//            Section("Resources") {
//                NavigationLink(destination: ResourceListView(course: viewModel.course)) {
//                    Text("see all resource")
//                }
//            }
            
            Section("Grade") {
                Text(String(format: "%.2f", viewModel.finalGrade))
            }
            
            Section {
                ForEach(viewModel.gradeitems, id:\.id) { gradeitem in
                    HStack {
                        Text(gradeitem.name ?? "")
                        Spacer()
                        Text(String(gradeitem.weight))
                        Spacer()
                        Text(String(format: "%.2f", gradeitem.grade))
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewModel.deleteItem(gradeitem: gradeitem)
                        } label : {
                            SwipeButtonView(text: "Delete", image: "trash.fill")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.editItem(gradeitem: gradeitem)
                        } label : {
                            SwipeButtonView(text: "Edit", image: "pencil")
                        }
                        .tint(.blue)
                    }
                }
                .id(UUID())

            } header : {
                HStack {
                    Text("Grade Items")
                    Spacer()
                    Button {
                        viewModel.showForm()
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationBarTitle(Text(viewModel.course?.name ?? "Coure Info"), displayMode: .inline)
        .alert("Add GradeItem", isPresented: $viewModel.showingForm, actions: {
            TextField("Name", text:  $viewModel.name)
            TextField("Weight", value:  $viewModel.weight, format: .number)
                .keyboardType(.decimalPad)
            TextField("Grade", value:  $viewModel.grade, format: .number)
                .keyboardType(.decimalPad)
            Button("Add", action: {viewModel.addGradeItem()})
            Button("Cancel", role: .cancel) { }
        }, message: {
            Text("Please enter the info for the grade item.")
        })
        .onDisappear {
            viewModel.saveCourse()
        }
    }
}

#Preview {
    CourseInfoView(course: CoursesListViewModel.course)
}
