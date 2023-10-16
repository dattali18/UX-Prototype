//
//  AssignmentsInfo.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/15/23.
//

import UIKit

class AssignmentsInfo: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var assignemnts: [Assignment] = []
    var course: Course?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = ""
        // Do any additional setup after loading the view.
        if(course != nil) {
            self.title = "\(course!.name!) - Assignments"
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension AssignmentsInfo : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assignemnts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignments", for: indexPath)
        
        cell.textLabel?.text = self.assignemnts[indexPath.row].descriptions
        
//        let (course, assignments) = self.sections[indexPath.section][indexPath.row]
//        
//        cell.courseLabel.text = course.name
//        cell.numberLabel.text = "\(assignments.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Assignments"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
//            let section = indexPath.section
            
            let assignment = self.assignemnts[row]
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(self.course?.name ?? "")?") { didConfirmDelete in
                if didConfirmDelete {
                    
                    self.assignemnts.remove(at: row)
                    self.tableView.reloadData()
                    
                    CoreDataManager.shared.delete(assignment)
                }
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
