//
//  AddProjectView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import SwiftUI

struct AddProjectView: View {
    weak var delegate: DisappearingViewDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: AddProjectViewModel
    
    init(project: Project? = nil) {
        _viewModel = StateObject(wrappedValue: AddProjectViewModel(project: project))
    }
    
    var body: some View {
        NavigationView
        {
            Form {
                Section("Course Info") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.descriptions)
                    TextField("URL", text: $viewModel.url)
                }
            }.navigationTitle(viewModel.navigationtitle)
        }
    }
}

#Preview {
    AddProjectView()
}
