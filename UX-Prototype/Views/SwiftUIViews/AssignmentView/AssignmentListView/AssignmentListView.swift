//
//  AssignmentListView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/29/23.
//

import SwiftUI

struct AssignmentListView: View {
    @StateObject var viewModel = AssignmentListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections, id:\.0) { category, section in
                    Section(category) {
                        ForEach(section, id:\.0) { name, assignments in
                            NavigationLink(destination: AssignmentsInfoView(course: name, type: category)) {
                                Text(name)
                                    .badge(assignments.count)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assignment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addAssignment()
                    } label : {
                        Label("Course", systemImage: "plus")
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
        .onAppear {
            viewModel.fetchData()
        }
        .onDisappear {
            viewModel.saveUserDefualt()
        }
        .sheet(isPresented: $viewModel.isPresented, onDismiss: {
            viewModel.fetchData()
        }) {
            AssignmentView()
        }

    }
}


//#Preview {
//    AssignmentListView()
//}
