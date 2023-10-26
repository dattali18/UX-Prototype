//
//  ResourceView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import SwiftUI

struct ResourceView: View {
    weak var delegate: DisappearingViewDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ResourceViewModel

    init(resource: Resource? = nil, course: Course? = nil) {
        _viewModel = StateObject(wrappedValue: ResourceViewModel(resource: resource, course: course))
    }
    

    var body: some View {
        NavigationView {
            Form {
                Section("Resource Info") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section {
                    TextField("Link Name", text: $viewModel.linkName)
                    TextField("URL", text: $viewModel.url)
                } header: {
                    Text("Link Info")
                } footer: {
                    VStack {
                        Text("Please enter the info of the link and thank click on the plus button to add it to the list.")
                        
                        Spacer()
                        
                        Button {
                            viewModel.addLink()
                        } label : {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Link")
                            }
                        }
                    }
                }
                
                Section("Links") {
                    ForEach(viewModel.links, id: \.self.id) { link in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(link.name ?? "")
                                .font(.headline)
                            
                            Text((link.url ?? "").toDetectedAttributedString())
                                .lineLimit(1)
                        }
                        .swipeActions(edge: .leading){
                            Button {
                                viewModel.deleteLink(with: link)
                            } label : {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.editLink(with: link)
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.navigationtitle)
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        if(viewModel.validateData()){
                            let _ = viewModel.saveData()
                            // Dismiss the view
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.showAlert()
                        }
                    } label: {
                        HStack {
                            Text("Save")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.mode == .edit {
                        Button {
                            viewModel.showDeleteAlert()
                        } label: {
                            HStack {
//                                Image(systemName: "trash.fill")
                                Text("Delete")
                            }
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $viewModel.deleteAlertShowing) {
                            Alert(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this semester?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteData()
                                    // Dismiss the view
                                    self.presentationMode.wrappedValue.dismiss()
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please enter all info before saving."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            self.delegate?.viewWillDisappear()
        }
    }
    
}

#Preview {
    ResourceView()
}

extension String {
    func toDetectedAttributedString() -> AttributedString {
        
        var attributedString = AttributedString(self)
        
        let types = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        
        guard let detector = try? NSDataDetector(types: types) else {
            return attributedString
        }
        
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        
        for match in matches {
            let range = match.range
            let startIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: range.lowerBound)
            let endIndex = attributedString.index(startIndex, offsetByCharacters: range.length)
            // Set the url for links
            if match.resultType == .link, let url = match.url {
                attributedString[startIndex..<endIndex].link = url
                // If it's an email, set the background color
                if url.scheme == "mailto" {
                attributedString[startIndex..<endIndex].backgroundColor = .red.opacity(0.3)
                }
            }
            // Set the url for phone numbers
            if match.resultType == .phoneNumber, let phoneNumber = match.phoneNumber {
                let url = URL(string: "tel:\(phoneNumber)")
                attributedString[startIndex..<endIndex].link = url
            }
        }
        return attributedString
    }
}
