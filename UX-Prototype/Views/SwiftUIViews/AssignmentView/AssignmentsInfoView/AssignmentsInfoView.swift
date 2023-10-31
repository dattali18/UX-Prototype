//
//  AssignmentsInfoView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/31/23.
//

import SwiftUI

struct AssignmentsInfoView: View {
    @StateObject var viewModel: AssignmentInfoViewModel
    
    init(course: String, type: String) {
        self._viewModel = StateObject(wrappedValue: AssignmentInfoViewModel(course: course, type: type))
    }
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.assignments[0], id:\.id) { assignment in
                    Text(assignment.name ?? "")
                }
            }
            
            Section {
                ForEach(viewModel.assignments[1], id:\.id) { assignment in
                    Text(assignment.name ?? "")
                }
            } header : {
                Text("Completed")
            }
        }
        .navigationTitle(viewModel.course?.name ?? "")
    }
}

//#Preview {
//    AssignmentsInfoView()
//}
