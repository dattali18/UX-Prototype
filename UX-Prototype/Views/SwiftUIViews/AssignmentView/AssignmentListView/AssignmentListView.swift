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
                ForEach(viewModel.sections, id:\.0) { option, section in
                    Section(option) {
                        ForEach(section, id:\.0) { name, assignments in
                            Text(name)
                                .badge(assignments.count)
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
