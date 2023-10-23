//
//  ProjectsView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/19/23.
//

import SwiftUI

struct ProjectsView: View {
    weak var delegate: DisappearingViewDelegate?
    weak var addProjectDelegate: AddProjectDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ProjectsViewModel
    
    init(resource: Resource? = nil, course: Course? = nil) {
        _viewModel = StateObject(wrappedValue: ProjectsViewModel())
    }
    
    var body: some View {
        NavigationView
        {
            Form
            {
                Section {
                    List(viewModel.projects, id:\.id) { project in
                        NavigationLink(destination: ProjectView(project: project)) {
                            HStack {
                                Image(project.icon!)
                                    .font(.largeTitle)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(project.name!)
                                    
                                    
                                    Text(project.descriptions ?? "")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                           
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                addProjectDelegate?.pushAddView(project: project)
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.showDeleteAlert()
                            } label : {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $viewModel.deleteAlertShowing) {
                            Alert(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this project?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteProject(project: project)

                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                } header : {
                    Text("Project")
                } footer : {
                    Text("Project Assignment.")
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addProjectDelegate?.pushAddView(project: nil)
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchProject()
            }
        }

    }
}

#Preview {
    ProjectsView()
}
