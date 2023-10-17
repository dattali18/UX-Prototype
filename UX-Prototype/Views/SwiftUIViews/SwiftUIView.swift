//
//  SwiftUIView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/12/23.
//

import SwiftUI

struct SwiftUIView: View {
    @State public var name: String = ""
    @State public var description: String = ""
    @State public var url: String = ""
    @State public var date = Date()
    @State public var time = Date()
    
    @State public var hasDate = false
    @State public var hasTime = false
    
    
    var body: some View {
        List {
            Section
            {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                TextField("URL", text: $url)
            }
            Section
            {
                Toggle("Date", isOn: $hasDate)
                
                if(hasDate || hasTime)
                {
                    DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                    }
                }
                
                Toggle("Time", isOn: $hasTime)
                
                if(hasTime)
                {
                    
                    DatePicker(selection: $time, in: ...Date(), displayedComponents: .hourAndMinute) {
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
