//
//  CoursesListView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct CoursesListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CoursesListViewModel = CoursesListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.sectionsName.enumerated()), id: \.element) { index, name in
                    Section {
                        ForEach(viewModel.courses[index], id: \.id) { course in
                            NavigationLink(destination: CourseInfoView(course: course)) {
                                CourseRowView(course: course)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.showDeleteAlert()
                                } label : {
                                    SwipeButtonView(text: "Delete", image: "trash.fill")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.editCourse(course: course)
                                } label : {
                                    SwipeButtonView(text: "Edit", image: "pencil")
                                }
                                .tint(.blue)
                            }
                            .alert(isPresented: $viewModel.deleteAlertShowing) {
                                Alert(
                                    title: Text("Delete?"),
                                    message: Text("Are you sure you want to delete this course?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.deleteCourse(course: course, index: index)
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                        }
                    } header : {
                        if name != viewModel.noSemester {
                            NavigationLink(
                                destination: SemesterInfoView(semester: viewModel.getSemesterByName(name: name)))
                            {
                                HStack {
                                    Text(name)
                                    Spacer()
                                    Button {
                                        viewModel.editSemester(name: name)
                                    } label : {
                                        Text("Edit")
                                    }
                                }
                            }
                            .font(.subheadline)
                        } else {
                            Text(name)
                        }
                    }
                }
                .id(UUID())
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetchData()
            }
            .onDisappear {
                viewModel.saveUserDefualt()
            }
            .sheet(isPresented: $viewModel.isPresented, onDismiss: {
                viewModel.fetchData()
            }) {
                if let action = viewModel.action {
                    switch action {
                        case .addCourse:
                        CourseView()
                        case .editCourse:
                        CourseView(with: viewModel.course)
                        case .addSemester:
                        SemesterView()
                        case .editSemester:
                        SemesterView(with: viewModel.semester)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.addCourse()
                        } label : {
                            Label("Course", systemImage: "plus")
                        }
                        
                        Button {
                            viewModel.addSemester()
                        } label : {
                            Label("Semester", systemImage: "plus")
                        }
                    } label :  {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(viewModel.options, id: \.self) { option in
                            Button {
                                viewModel.selectedOption = option
                                viewModel.fetchData()
                            } label : {
                                if viewModel.selectedOption == option {
                                    Label(option, systemImage: "checkmark")
                                } else {
                                    Text(option)
                                }
                            }
                        }
                    } label : {
                        Label("Filter", systemImage: "list.bullet")
                    }
                }
            }
        }
    }
}

#Preview {
    CoursesListView()
}
