//
//  CourseView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CourseViewModel
    
    init(with course: Course? = nil) {
        _viewModel = StateObject(wrappedValue: CourseViewModel(with: course))
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section
                {
                    TextField("Course Name", text: $viewModel.name)
                    
                    TextField("Course Number", text: Binding(
                            get: { viewModel.stringnumber },
                            set: { viewModel.stringnumber = $0.filter{ "0123456789".contains($0) } }
                        )
                    )
                    .keyboardType(.numberPad)
                    
                    TextField("Course Credits", value: $viewModel.credits, format: .number)
                        .keyboardType(.decimalPad) 
                    
                } header : {
                    Text("Course Info")
                } footer : {
                    Text("Please enter all info before saving")
                }
                
//                Section("Grade") {
//                    TextField("Final Grade",value: $viewModel.grade, format: .number)
//                        .keyboardType(.decimalPad)
//                }
                
                Section {
                    Toggle(isOn: $viewModel.hasSemester, label: {
                        HStack {
                            Image(systemName: "graduationcap.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                            Text("Semester")
                        }
                    })
                    .tint(.pink)
                    
                    if viewModel.hasSemester
                    {
                        Picker("Type", selection: $viewModel.selectedSemester) {
                            ForEach(0..<viewModel.semesters.count, id: \.self) { index in
                                Text(viewModel.semesters[index].name ?? "").tag(viewModel.semesters[index].name ?? "")
                            }
                        }
                    }
                } header : {
                    Text("Connect To Semester")
                }
            }
            .navigationTitle(viewModel.navigationtitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if(viewModel.validateInpute()) {
                            let _ = viewModel.saveCourse()
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.showingAlert()
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Please enter all info before saving."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    CourseView()
}
