//
//  AssignmentsInfo.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/15/23.
//

import UIKit
import SwiftUI

class AssignmentsInfo: UIViewController {
    @IBOutlet weak var tableView: UITableView!
        
    var assignemnts: [Assignment] = []
    var course: Course?
    var type: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if(course != nil) {
            self.title = "\(course!.name!) - Assignments"
        }
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }

}

extension AssignmentsInfo: DisappearingViewDelegate {
    func viewWillDisappear() {
        // This function will be called from the SwiftUI view
        // when it is about to disappear
        // You can perform actions here
        fetchData()
    }
}

// MARK: - Table View
extension AssignmentsInfo : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assignemnts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignments", for: indexPath)
        
        cell.textLabel?.text = self.assignemnts[indexPath.row].name
        
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
    
    // MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
//            let section = indexPath.section
            
            let assignment = self.assignemnts[row]
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete this assignemnt?") { didConfirmDelete in
                if didConfirmDelete {
                    
                    self.assignemnts.remove(at: row)
                    self.tableView.reloadData()
                    
                    CoreDataManager.shared.delete(assignment)
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = self.assignemnts[indexPath.row]
        
        var assignmentView = AssignmentView(with: assignment)
        // implementing the obeserver pattern
        assignmentView.delegate = self
        let hostingController = UIHostingController(rootView: assignmentView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
}
// MARK: - Data Fetching
extension AssignmentsInfo {
    func fetchData() {
        self.assignemnts = []
        
        if(self.course == nil || self.type == nil) {
            self.tableView.reloadData()
            return
        }
        
        self.assignemnts = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        self.assignemnts = self.assignemnts.filter {$0.course == self.course && $0.type == self.type}
        
        self.tableView.reloadData()
    }
}
