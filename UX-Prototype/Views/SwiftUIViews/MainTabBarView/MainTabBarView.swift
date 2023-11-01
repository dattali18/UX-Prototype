//
//  MainTabBarView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 11/1/23.
//

import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        TabView {
            CoursesListView()
                .tabItem {
                    Label("Courses", systemImage: "book.closed.fill")
                }
            
            AssignmentListView()
                .tabItem {
                    Label("Assignments", systemImage: "list.bullet.clipboard.fill")
                }
            
            ProjectsView()
                .tabItem {
                    Label("Projects", systemImage: "tray.full.fill")
                }
        }
    }
}

#Preview {
    MainTabBarView()
}
