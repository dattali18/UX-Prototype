//
//  ResourceViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import Foundation


class ResourceViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var linkName: String = ""
    @Published var url: String = ""
    
    @Published var links: [Link] = []
    @Published var selectedLink: Int = 0
    
    @Published var showingAlert: Bool = false
    @Published var deleteAlertShowing: Bool = false
    @Published var deleteAlertResponse: Bool = false
    
    var resource: Resource?
    var course: Course?
    
    var mode: Mode = .add
    
    @Published var navigationtitle: String = "Add Resource"
    
    init(resource: Resource? = nil, course: Course? = nil) {
        self.resource = resource
        self.course = course
        
        if(self.resource != nil) {
            mode = .edit
            navigationtitle = "Edit Resource"
        }
        
        fetchData()
    }
    
    func fetchData() {
        name = self.resource?.name ?? ""
        description = self.resource?.descriptions ?? ""
        
        let linksSet = resource?.links ?? NSSet()
        
        for link in linksSet {
            links.append(link as! Link)
        }
    }
    
    func addLink() {
        if(linkName == "" || url == "") {
            showAlert()
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        
        let link = Link(context: managedObjectContext)
        
        link.id = UUID()
        link.name = linkName
        link.url = url
        
        links.append(link)
        
        linkName = ""
        url = ""
    }
    
    func validateData() -> Bool {
        return name != ""
    }
    
    func saveData() -> Resource? {
        // adding the link
        addLink()
        
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add)
        {
            self.resource = Resource(context: managedObjectContext)
            resource?.id = UUID()
        }
        
        resource?.name = name
        resource?.descriptions = description
        resource?.links = NSSet(array: links)
        resource?.course = self.course
        
        do {
          try managedObjectContext.save()
          return resource
        } catch {
          print("Error creating entity: \(error)")
          return nil
        }
    }
    
    func deleteData() {
        CoreDataManager.shared.delete(self.resource)
    }
    
    func showAlert() {
        showingAlert = true
    }
    
    func showDeleteAlert() {
        deleteAlertShowing = true
    }
    
    func editLink(with link: Link) {
        let index = self.links.firstIndex(of: link) ?? 0
        let link = links[index]
        
        self.links.remove(at: index)
        
        linkName    = link.name ?? ""
        url         = link.url ?? ""
        
    }
    
    func deleteLink(with link: Link) {
        let index = self.links.firstIndex(of: link) ?? 0
        
        self.links.remove(at: index)
    }
}
