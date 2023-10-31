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
        }
    }
}

//#Preview {
//    AssignmentListView()
//}
