//
//  CourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import CoreData

class CourseVC: UIViewController {
    
    var courses: [Course] = []
    var semesters: [Semester] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "CustomViewCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomViewCellTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCourses()
        fetchSemesters()
        

        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchCourses()
        fetchSemesters()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            // TODO: fix the bugs in the index formula
            let index = indexPath.section * tableView.numberOfRows(inSection: indexPath.section) + indexPath.row
            
            let name = self.courses[index].name
            
            
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(name ?? "")?") { didConfirmDelete in
                
                if didConfirmDelete {
                    self.courses.remove(at: index)
                    
                    self.tableView.reloadData()
                    
//                    if(tableView.numberOfRows(inSection: indexPath.section) == 1) {
//                        self.tableView.deleteSections([indexPath.section], with: .automatic)
//                    } else {
//                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    CoreDataManager.shared.delete(entity: Course.self, with: ["name": name])
                    
                }
            }
            
        }
        
        let editAction  = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            // Get the name of the course
            let name = self.courses[indexPath.row].name

            let vc = self.storyboard?.instantiateViewController(identifier: "editCourseVC") as! editCourseVC
            vc.courseNameTxt = name

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }

    private func fetchCourses() {
        courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        courses.sort { $0.semester?.str ?? "" < $1.semester?.str ?? "" }
       }

   private func fetchSemesters() {
       semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
   }
}


extension CourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row), \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let semester = semesters[section]
        let coursesForSemester = courses.filter { $0.semester == semester }
        return coursesForSemester.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCellTableViewCell", for: indexPath) as! customViewCellTableViewCell
        
        cell.courseName.text = courses[indexPath.row].name

        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return semesters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let semester = semesters[section]
        return semester.str
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

