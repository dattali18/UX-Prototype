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
    
    @Published var isPresented: Bool = false
    var action : ResourceActionType?
    var resource: Resource?
    
    @Published var showingLinkField: Bool = false
    @Published var linkName: String = ""
    @Published var linkUrl: String = ""
    
    @Published var showingDeleteAlert: Bool = false
    
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
    
    func addResource() {
        self.action = .add
        self.isPresented = true
    }
    
    func editResource(resource: Resource?) {
        self.action = .edit
        self.isPresented = true
        self.resource = resource
    }
    
    func deleteLink(link: Link, index: Int) {
        // removing from list
        self.links[index].removeAll(where: { $0 == link})
        
        CoreDataManager.shared.delete(link)
    }
    
    func editLink(link : Link, resource: Resource, index: Int) {
        self.linkName = link.name ?? ""
        self.linkUrl = link.url ?? ""
        // removing from list
        self.links[index].removeAll(where: { $0 == link})
        CoreDataManager.shared.delete(link)
        
        self.showingLinkField = true
        // putting info in the field
        self.resource = resource
    }
    
    func saveEditedLink() {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        let link: Link =  Link(context: managedObjectContext)
        link.name = self.linkName
        link.url = self.linkUrl
        link.id = UUID()
        self.resource?.addToLinks(link)
        
        do {
          try managedObjectContext.save()
        } catch {
          print("Error creating entity: \(error)")
        }
        
        self.fetchData()
    }
    
    func showDeleteAlert() {
        self.showingDeleteAlert = true
    }
}

enum ResourceActionType {
    case add
    case edit
}
