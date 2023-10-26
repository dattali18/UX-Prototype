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
                        VStack(alignment: .leading) {
                            Text(link.name ?? "")
                            Text((link.url ?? "").toDetectedAttributedString())
                                .lineLimit(1)
                        }
                    }
                } header : {
                    HStack {
                        Text(resource.name!)
                        Spacer()
                        Button("Edit") {
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
    }
}

#Preview {
    ResourceListView(course: nil)
}
