//
//  ProjectsView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/19/23.
//

import SwiftUI

struct ProjectsView: View {
    weak var delegate: DisappearingViewDelegate?
    
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
                            
                            Image(systemName: "chevron.forward")
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
                        
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
        }

    }
}

#Preview {
    ProjectsView()
}
