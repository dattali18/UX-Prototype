//
//  SwipeButtonView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct SwipeButtonView: View {
    var text: String
    var image: String
    
    var body: some View {
        VStack {
           Text(text)
            
            Spacer()
            
            Image(systemName: image)
        }
    }
}

//#Preview {
//    SwipeButtonView()
//}
