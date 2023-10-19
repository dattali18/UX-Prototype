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
    
    var resource: Resource?
    var course: Course?
    var mode: Mode = .add
    
    init(resource: Resource? = nil, course: Course? = nil) {
        self.resource = resource
        self.course = course
        fetchData()
    }
    
    func fetchData() {
        
        if(self.resource == nil) {
            return
        }
        
        mode = .edit
        
        let linksSet = resource?.links ?? NSSet()
        
        for link in linksSet {
            links.append(link as! Link)
        }
//        
//        let managedObjectContext = CoreDataManager.shared.managedObjectContext
//        
//        let names = ["Moddle", "ChatGPT", "GitHub"]
//        let urls = ["https://apps4world.com/add-core-data-swiftui-tutorial.html","https://chat.openai.com/c/708527b8-69b2-495c-a95a-7607b96f45de", "https://github.com"]
//        
//        for i in 0...2 {
//            let link = Link(context: managedObjectContext)
//            
//            link.id = UUID()
//            link.name = names[i]
//            link.url = urls[i]
//            
//            links.append(link)
//        }
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
        return !(name == "" || description == "")
    }
    
    func saveData() -> Resource? {
        // adding the link
        addLink()
        
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add)
        {
            self.resource = Resource(context: managedObjectContext)
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
    
    func showAlert() {
        showingAlert = true
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
