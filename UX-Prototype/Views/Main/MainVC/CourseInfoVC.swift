import UIKit

class CourseInfoVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var course: Course?
    var resources: [Resource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ResourcesTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ResourcesTVC")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Course Name"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .systemBackground
        self.tableView.backgroundColor = .systemBackground
        
        // Create a new navigation bar button item
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewResource))


        // Add the navigation bar button item to the navigation bar
        self.navigationItem.rightBarButtonItem = navigationButton
        
        if(course != nil) {
            self.title = self.course?.name
            
            self.resources = CoreDataManager.shared.fetchResources(for: self.course!)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(course != nil) {
            self.title = self.course?.name
            
            self.resources = CoreDataManager.shared.fetchResources(for: self.course!)
        }
        
        tableView.reloadData()
    }
    
    @objc func addNewResource() {
      // Implement the logic for adding a new resource to the course
        
    }

}

extension CourseInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesTVC", for: indexPath) as! ResourcesTVC
        
        cell.nameLabel.text = self.resources[indexPath.row].name
        cell.descriotionLabel.text = self.resources[indexPath.row].descriptions

        return cell
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
}
