//
//  CourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import CoreData

class CourseVC: UIViewController {
    
    var list: [Course]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "CustomViewCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomViewCellTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        

        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        list = CoreDataManager.shared.fetch(entity: Course.self)

        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let name = self.list?[indexPath.row].name
            
            
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(name ?? "")?") { didConfirmDelete in
                
                if didConfirmDelete {

                    self.list?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    CoreDataManager.shared.delete(entity: Course.self, with: ["name": name])
                }
            }
            
        }
        
        let editAction  = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            // Get the name of the course
            let name = self.list?[indexPath.row].name

            let vc = self.storyboard?.instantiateViewController(identifier: "editCourseVC") as! editCourseVC
            vc.courseNameTxt = name

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }

}


extension CourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCellTableViewCell", for: indexPath) as! customViewCellTableViewCell
        
        cell.courseName.text = list?[indexPath.row].name

        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Spring Semester"
        }
        return "Another Secttion"
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

