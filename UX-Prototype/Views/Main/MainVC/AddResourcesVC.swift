//
//  AddResourcesVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/9/23.
//

import UIKit

// TODO: 1. add a save button with all check and save it to core data
// TODO: 2. add swip action to delete link from list

class AddResourcesVC: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var linkNameField: UITextField!
    @IBOutlet weak var linkUrlField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var course: Course?
    var links: [Link] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "LinkTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "LinkTVC")

        // Do any additional setup after loading the view.
        if(course != nil) {
            self.title = "Add Resource To \(self.course!.name!)"
        } else {
            self.title = "Add Resource To None"
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.view.backgroundColor = .systemBackground
        self.tableView.backgroundColor = .systemBackground
    }
    
    @IBAction func addLinkBtn(_ sender: Any) {
        let name = linkNameField.text
        let url = linkUrlField.text
        
        if(name == "" || url == "") {
            self.showErrorAlert(message: "Please fill out the Link Name and Url before adding it to the list")
            return
        }
        
        let link = CoreDataManager.shared.create(entity: Link.self, with: ["name": name, "url": url])
        
        if(link != nil)
        {
            self.links.append(link!)
        }
        
        linkNameField.text  = ""
        linkUrlField.text   = ""

        self.tableView.reloadData()
    }
    
    @IBAction func addRescourceBtn(_ sender: Any) {
//        self.showInfoAlert(message: "Please add all links before saving.")
        let name = self.nameField.text
        let description = self.descriptionField.text
        let links = self.links
        
        if(name == "" || description == "") {
            self.showErrorAlert(message: "Please fill in the name and description before saving.")
            return
        }
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        let newResource = Resource(context: managedObjectContext)
        
        newResource.name = name
        newResource.descriptions = description
        
        for link in self.links {
            newResource.addToLinks(link)
        }
        
        newResource.course = self.course
        
        managedObjectContext.insert(newResource)
        
        do {
          try managedObjectContext.save()
        } catch {
          print("Error creating entity: \(error)")
          return
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddResourcesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LinkTVC", for: indexPath) as! LinkTVC
        
        let link = self.links[indexPath.row]
        
        cell.nameLabel.text = link.name
        cell.urlLabel.text = link.url

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Links"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let link = self.links[indexPath.row]
            let index = self.links.firstIndex(of: link)
            
            self.links.remove(at: index!)
            
            self.tableView.reloadData()
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
}
