//
//  CourseInfoView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct CourseInfoView: View {
    var course: Course?
    
    var body: some View {
        Form {
            Section("Course Info") {
                Text("Name")
                    .badge(Text(course?.name ?? "None"))
                    
                
                Text("Number")
                    .badge(Text(String(course?.number ?? 0)))
                
                Text("Creadits")
                    .badge(Text(String(course?.credits ?? 0.0)))
            }
            
            Section("Grade Items") {
                HStack {
                    Text("Final Test")
                    Spacer()
                    Text("0.70")
                    Spacer()
                    Text("98")
                }
            }
        }
        .navigationBarTitle(Text(course?.name ?? "Coure Info"), displayMode: .inline)
    }
}

#Preview {
    CourseInfoView(course: CoursesListViewModel.course)
}
