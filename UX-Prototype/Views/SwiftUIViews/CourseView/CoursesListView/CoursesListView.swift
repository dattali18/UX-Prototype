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
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.editCourse(course: course)
                                } label : {
                                    SwipeButtonView(text: "Edit", image: "pencil")
                                }
                                .tint(.blue)
                            }
                            }
                    } header : {
                        HStack {
                            Text(name)
                            Spacer()
                            Button {
                                viewModel.editSemester(name: name)
                            } label : {
                                Text("Edit")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetchData()
            }
            .sheet(isPresented: $viewModel.isPresented) {
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
        }
    }
}

#Preview {
    CoursesListView()
}
