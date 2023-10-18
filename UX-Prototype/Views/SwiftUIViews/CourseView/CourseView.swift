//
//  CourseView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import SwiftUI

struct CourseView: View {
    @StateObject var viewModel = CourseViewModel()

    
    var body: some View {
        NavigationView {
            Form {
                
                Section
                {
                    TextField("Course Name", text: $viewModel.name)
                    TextField("Course Number", value: $viewModel.number, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Course Credits", value: $viewModel.credits, format: .number)
                        .keyboardType(.decimalPad)
                    
                } header : {
                    Text("Course Info")
                } footer : {
                    Text("Please enter all info before saving")
                }
                
                Section {
                    Toggle(isOn: $viewModel.haveSemester, label: {
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(.blue)
                            Text("Semester")
                        }
                    })
                    
                    if viewModel.haveSemester
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
                
                Section {
                    
                } footer : {
                    Button {
                        viewModel.saveCourse()
                    } label: {
                        HStack
                        {
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                        .frame(width: 350, height: 30)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .navigationTitle("New Course")
            .onTapGesture {
                    hideKeyboard()
            }
        }
    }
}

#Preview {
    CourseView()
}
