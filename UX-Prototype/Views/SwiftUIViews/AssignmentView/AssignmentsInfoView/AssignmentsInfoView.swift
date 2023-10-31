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
                    AssignmentListRowView(assignment: assignment)
                        .swipeActions(edge: .trailing) {
                            Button {
                                
                            } label : {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
                            
                            Button {
                                
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                assignment.done.toggle()
                                viewModel.fetchData()
                            } label : {
                                Label("Complete", systemImage: "checkmark.circle")
                            }
                            .tint(.green)
                        }
                }
            }
            
            Section {
                ForEach(viewModel.assignments[1], id:\.id) { assignment in
                    AssignmentListRowView(assignment: assignment)
                        .swipeActions(edge: .trailing) {
                            Button {
                                
                            } label : {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
                            
                            Button {
                                
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                assignment.done.toggle()
                                viewModel.fetchData()
                            } label : {
                                Label("Uncomplete", systemImage: "x.circle")
                            }
                            .tint(.red)
                        }
                }
            } header : {
                Text("Completed")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.course?.name ?? "")
    }
}

struct AssignmentListRowView : View {
    var assignment: Assignment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(assignment.name ?? "")
                Spacer()
                Text(dateFormatter(assignment.due))
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            
            if(assignment.descriptions != nil) {
                HStack {
                    Text(assignment.descriptions ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            if(assignment.url != nil) {
                HStack {
                    Text(assignment.url ?? "")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    func dateFormatter(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "E d MMM"
        
        // Convert the Date to a String
        return dateFormatter.string(from: date)
    }
}
//#Preview {
//    AssignmentsInfoView()
//}
