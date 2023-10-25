//
//  SemesterInfoView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct SemesterInfoView: View {
    weak var delegate: DisappearingViewDelegate?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: SemesterInfoViewModel

    init(semester: Semester? = nil) {
        _viewModel = StateObject(wrappedValue: SemesterInfoViewModel(semester: semester))
    }
    
    var body: some View {
        List {
            Section("Semester info") {
                Text("Name")
                    .badge(Text(viewModel.name))
                Text("Start")
                    .badge(Text(viewModel.startDate))
                Text("End")
                    .badge(Text(viewModel.endDate))
            }
            
            Section("Totals") {
                Text("Total courses")
                    .badge(Text(String(viewModel.totalCourses)))
                
                Text("Total credits")
                    .badge(Text(String(viewModel.totalCredits)))
            }
            
            
            Section {
                Text("Avrage")
                    .badge(Text(String(format: "%.2f", viewModel.avg)))
            } header : {
                Text("Grade")
            } footer : {
                Text("This is a wighted avarge, based on course credits.")
            }
            
            Section("Courses") {
                ForEach(viewModel.courses) { course in
                    HStack {
                        Text(course.name ?? "")
                            .badge(Text(String(course.credits)))
                    }
                }
            }
        }
    }
}

#Preview {
    SemesterInfoView(semester: SemesterInfoViewModel.semester)
}
