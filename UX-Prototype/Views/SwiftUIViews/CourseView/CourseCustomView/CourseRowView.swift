//
//  CourseRowView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct CourseRowView: View {
    var course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(course.name ?? "None")
                .fontWeight(.semibold)
                .badge(Text(String(course.credits)))
            
            Text(String(course.number))
                .foregroundStyle(.blue)
        }
    }
}

