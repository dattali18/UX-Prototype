//
//  SemesterView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import SwiftUI

struct SemesterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: SemesterViewModel

    init(with semester: Semester? = nil) {
        _viewModel = StateObject(wrappedValue: SemesterViewModel(with: semester))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(0..<viewModel.types.count, id: \.self) {index in
                            Text(viewModel.types[index])
                        }
                    }
                }
                
                Section("Dates") {
                    DatePicker("Start Date", selection: $viewModel.start, displayedComponents: [.date])
                    
                    DatePicker("End Date", selection: $viewModel.end, displayedComponents: [.date])
                    
                }
        
            }
            .navigationTitle(viewModel.navigationtitle)
            .alert(isPresented: $viewModel.isShowing) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Please make sure the end date is after the start date."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if(viewModel.validateInput()) {
                            let _ = viewModel.saveSemester()
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.showAlert()
                        }  
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.mode == .edit {
                        Button {
                            viewModel.showDeleteAlert()
                        } label: {
                            HStack {
                                Text("Delete")
                            }
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $viewModel.deleteAlertShowing) {
                            Alert(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this semester?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteSemester()
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
    }
}

#Preview {
    SemesterView()
}
