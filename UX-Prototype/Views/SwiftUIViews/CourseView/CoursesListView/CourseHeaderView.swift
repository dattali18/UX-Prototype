//
//  CourseHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct CourseHeaderView: View {
    var sectionName: String
    
    var body: some View {
        HStack {
            Text(sectionName)
            
            Spacer()
            
            Button {
                
            } label : {
                Text("Edit")
                    .font(.caption)
            }
        }
    }
}


