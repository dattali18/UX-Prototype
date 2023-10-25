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
                ForEach(0..<viewModel.sectionCount) { index in
                    Section {
                        ForEach(viewModel.courses[index], id: \.id) { course in
                            NavigationLink(destination: CourseInfoView(course: course)) {
                                CourseRowView(course: course)
                            }
                            
                        }
                    } header : {
                        CourseHeaderView(sectionName: viewModel.sectionsName[index])
                    }
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

#Preview {
    CoursesListView()
}
