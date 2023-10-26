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
                            }
                    } header : {
                        CourseHeaderView(sectionName: name)
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
                            CourseView()
                        case .editSemester:
                            CourseView()
                    }
                }
            }
        }
    }
}

#Preview {
    CoursesListView()
}
