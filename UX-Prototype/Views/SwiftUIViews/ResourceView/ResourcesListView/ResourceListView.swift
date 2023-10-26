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
        Text("hi")
//        List {
//            ForEach(Array(viewModel.resources.enumerated()), id: \.element) { (index, resource) in
//                Section {
//                    ForEach(viewModel.links[index], id: \.id) { link in
//                        VStack {
//                            Text(link.name ?? "")
//                            Text(link.url ?? "")
//                        }
//                    }
//                } header : {
//                    VStack {
//                        Text(resource.name!)
//                        Button("Edit") {
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle("Resources")
//        .onAppear {
//            viewModel.fetchData()
//        }
    }
}

#Preview {
    ResourceListView(course: nil)
}
