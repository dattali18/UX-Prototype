//
//  ResourceListView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/26/23.
//

import Foundation

class ResourceListViewModel : ObservableObject {
    @Published var course: Course?
    @Published var resources: [Resource] = []
    @Published var links: [[Link]] = []
    
    init(course: Course?) {
        self.course = course
    }
    
    func fetchData() {
        guard let course = self.course else { return }
        
        self.resources = []
        self.links = []
        
        self.resources = CoreDataManager.shared.fetch(entity: Resource.self) ?? []
        self.resources = self.resources.filter { $0.course == course }
        
        self.links = self.resources.map { $0.links?.allObjects as! [Link] }
    }
}
