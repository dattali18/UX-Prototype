//
//  AddResourcesVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/9/23.
//

import UIKit

enum Mode {
case edit
case add
    
}

class AddResourcesVC: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var linkNameField: UITextField!
    @IBOutlet weak var linkUrlField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainBtn: UIButton!
    
    var course: Course?
    var links: [Link] = []
    var resource: Resource?
    var mode: Mode = .add
    
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
        
        self.view.backgroundColor = .secondarySystemBackground
        
        // if the mode == true we are in add mode
        if(mode == .edit) {
            if(self.resource != nil) {
                self.links = CoreDataManager.shared.fetchLinks(for: self.resource!)
                
                self.nameField.text = self.resource?.name
                self.descriptionField.text = self.resource?.descriptions
                
                self.tableView.reloadData()
                
                self.mainBtn.setTitle("Save", for: .normal)
            }
            
            // Create a new navigation bar button item
            let navigationButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteResource))
            
            navigationButton.tintColor = .systemRed

            // Add the navigation bar button item to the navigation bar
            self.navigationItem.rightBarButtonItem = navigationButton
        }
    }
    
    @objc func deleteResource() {
        self.showDeleteConfirmationAlert(message: "Confirm deleting this resource", completion: {
            confirm in
            if(confirm) {
                CoreDataManager.shared.delete(self.resource)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    @IBAction func addLinkBtn(_ sender: Any) {
        let name = linkNameField.text
        let url = linkUrlField.text
        
        if(name == "" || url == "") {
            self.showErrorAlert(message: "Please fill out the Link Name and Url before adding it to the list")
            return
        }
        
        let link = CoreDataManager.shared.create(entity: Link.self, with: ["name": name as Any, "url": url as Any])
        
        if(link != nil)
        {
            self.links.append(link!)
        }
        
        linkNameField.text  = ""
        linkUrlField.text   = ""

        self.tableView.reloadData()
    }
    
    @IBAction func addRescourceBtn(_ sender: Any) {
        let name = self.nameField.text
        let description = self.descriptionField.text
        
        if(name == "" || description == "") {
            self.showErrorAlert(message: "Please fill in the name and description before saving.")
            return
        }
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add)
        {
            let newResource = Resource(context: managedObjectContext)
            
            newResource.name = name
            newResource.descriptions = description
            
 
            let linksSet = NSSet(array: self.links)
            newResource.links = linksSet
            
            newResource.course = self.course
            
            managedObjectContext.insert(newResource)
        } else {
            self.resource?.name = name
            self.resource?.descriptions = description
            
            // Convert the array to a set.
            let linksSet = NSSet(array: self.links)
            
            self.resource?.links = linksSet
        }
        
        do {
          try managedObjectContext.save()
        } catch {
          print("Error creating entity: \(error)")
          return
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View
extension AddResourcesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LinkTVC", for: indexPath) as! LinkTVC
        
        let link = self.links[indexPath.row]
        
        cell.nameLabel.text = link.name
        cell.UrlText.text = link.url

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
    
    // MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let link = self.links[indexPath.row]
            let index = self.links.firstIndex(of: link)
            
            self.links.remove(at: index!)
            
            self.tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            
            let link = self.links[indexPath.row]
            let index = self.links.firstIndex(of: link)
            
            self.links.remove(at: index!)
            
            self.linkNameField.text = link.name
            self.linkUrlField.text = link.url
            
            self.tableView.reloadData()
        }
        editAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }
    
}
