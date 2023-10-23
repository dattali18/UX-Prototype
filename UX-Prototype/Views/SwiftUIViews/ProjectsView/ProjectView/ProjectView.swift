//
//  ProjectView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import SwiftUI

struct ProjectView: View {
    @ObservedObject var viewModel = ProjectViewModel()
    
    var body: some View {
        NavigationView { // You can wrap the list in a NavigationView for navigation purposes
            Form {
                Section {
                    Text("Project Name")
                    Text("Project Description")
                    Text("Project URL")
                }
                
                Section {
                    List(viewModel.commits, id: \.id) { commit in
                        VStack(alignment: .leading) {
                            Text(commit.authorName)
                                .font(.headline)
                            Text(commit.commitDate)
                                .font(.subheadline)
                            Text(commit.commitMessage)
                                .font(.body)
                        }
                    }
                    
                    
                    if viewModel.isFetchingData {
                        ProgressView("Fetching data...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationBarTitle("Project") // Set a navigation title
            .onAppear {
                if !viewModel.isFetchingData {
                    viewModel.fetchData()
                }
            }
        }
    }
}


#Preview {
    ProjectView()
}
