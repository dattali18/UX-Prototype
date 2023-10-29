//
//  ResourceListView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/26/23.
//

import SwiftUI

struct ResourceListView: View {
    @StateObject var viewModel: ResourceListViewModel
    
    init(course: Course?) {
        self._viewModel = StateObject(wrappedValue: ResourceListViewModel(course: course))
    }
    
    var body: some View {
        List {
            ForEach(Array(viewModel.resources.enumerated()), id: \.element) { (index, resource) in
                Section {
                    ForEach(viewModel.links[index], id: \.id) { link in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(link.name ?? "")
                            Text((link.url ?? "").toDetectedAttributedString())
                                .textSelection(.enabled)
                                .lineLimit(1)
                        }
                        .frame(height: 74)
                        .swipeActions(edge: .trailing){
                            Button {
                                viewModel.showDeleteAlert()
                            } label : {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.editLink(link: link, resource: resource, index: index)
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .alert(isPresented: $viewModel.showingDeleteAlert) {
                            Alert(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this link?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteLink(link: link, index: index)
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                } header : {
                    HStack {
                        Text(resource.name!)
                        Spacer()
                        Button {
                            viewModel.editResource(resource: resource)
                        } label : {
                            Text("Edit")
                                .font(.subheadline)
                        }
                    }
                } footer : {
                    Text(resource.descriptions ?? "")
                }
            }
        }
        .navigationTitle("Resources")
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $viewModel.isPresented, onDismiss: {
            viewModel.fetchData()
        }) {
            if let action = viewModel.action {
                switch action {
                    case .add:
                    ResourceView()
                    case .edit:
                    ResourceView(resource: viewModel.resource, course: viewModel.course)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addResource()
                } label : {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Edit Link", isPresented: $viewModel.showingLinkField, actions: {
            TextField("Name", text:  $viewModel.linkName)
            TextField("URL", text:  $viewModel.linkUrl)
            Button("Save", action: {viewModel.saveEditedLink()})
            Button("Cancel", role: .cancel) { }
        }, message: {
            Text("Please enter the info for the link item.")
        })
    }
}

#Preview {
    ResourceListView(course: nil)
}
