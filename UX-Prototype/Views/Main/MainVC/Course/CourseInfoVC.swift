import UIKit
import MessageUI


class CourseInfoVC: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var course: Course?
    var resources: [Resource] = []
    var links: [[Link]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "LinkTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "LinkTVC")
        
        tableView.register(UINib(nibName: "ResourcesSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ResourcesSectionHeaderView")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Course Name"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .secondarySystemBackground
        
        // Create a new navigation bar button item
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewResource))
        
        // Add the navigation bar button item to the navigation bar
        self.navigationItem.rightBarButtonItem = navigationButton
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchData()
    }
    
    @objc func addNewResource() {
      // Implement the logic for adding a new resource to the course
        let vc = self.storyboard?.instantiateViewController(identifier: "AddResourcesVC") as! AddResourcesVC
        
        if(self.course != nil) {
            vc.course = self.course
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Data Fetching
extension CourseInfoVC {
    func fetchData() {
        if(self.course == nil) {
            return
        }
        
        self.resources = []
        self.links = []
        
        self.resources = CoreDataManager.shared.fetchResources(for: self.course!)
        
        for resource in resources {
            
            let linksSet = resource.links ?? []
            var linksArray = [Link]()

            for link in linksSet {
                linksArray.append(link as! Link)
            }
            
            self.links.append(linksArray)
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Table View
extension CourseInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.resources.isEmpty || self.resources.count < section) {
            return 0
        }
        
        return self.links[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTVC", for: indexPath) as! LinkTVC
        
        let linksArray = self.links[indexPath.section]
        
        if(linksArray.isEmpty) {
            return cell
        }
        let link = linksArray[indexPath.row]
        
        cell.nameLabel.text = link.name
        cell.UrlText.text  = link.url

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resources.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < self.resources.count
        {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ResourcesSectionHeaderView") as? ResourcesSectionHeaderView {
                
                let resource = self.resources[section]
                
                headerView.nameLabel.text        = resource.name
                headerView.decriptionLabel.text  = resource.descriptions
                
                headerView.course = self.course
                headerView.resource = resource
                headerView.navigationController = self.navigationController
                headerView.storyboard = self.storyboard
                
                return headerView
            } else {
                print(section)
                return nil
            }
        } else {
            // Return a header view for the section for courses without semester.
            let headerView = UITableViewHeaderFooterView()
            headerView.textLabel?.text = "Courses Without Semester"
            return headerView
          }
    }

    // MARK: siwpe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete this link?") { didConfirmDelete in
                if(didConfirmDelete)
                {
                    let link = self.links[indexPath.section][indexPath.row]
                    
                    CoreDataManager.shared.delete(link)
                    
                    self.fetchData()
                }
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in

            let addResource = self.storyboard?.instantiateViewController(identifier: "AddResourcesVC") as! AddResourcesVC
            
            addResource.resource = self.resources[indexPath.section]
            addResource.mode = .edit
            addResource.course = self.course

            self.navigationController?.pushViewController(addResource, animated: true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }

}
