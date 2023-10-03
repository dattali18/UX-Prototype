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
        
        tableView.rowHeight = 44
 
        // Do any additional setup after loading the view.
        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .secondarySystemBackground
        tableView.backgroundColor = .secondarySystemBackground

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        list = fetchAllCourses()
        tableView.reloadData()
        
//        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
//        do {
//            let courses = try CoreDataStack.shared.managedObjectContext.fetch(fetchRequest)
//            // Process fetched courses
//            list = courses
//            tableView.reloadData()
//        } catch {
//            print("Error fetching data: \(error.localizedDescription)")
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            let name = self.list?[indexPath.row].name
            
            self.list?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteCourse(withName: name)
        }
        
        let editAction  = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            // TODO: pop up new UIView
            print("hi from here")
        }
        
        editAction.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, indexPath in
//
//            let name = self.list?[indexPath.row].name
//            
//            self.list?.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//        
//            
//            deleteCourse(withName: name)
//        })
//        
//        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: {
//        action, indexPath in
//        // TODO: pop up new UIView
//            print("hi from here")
//        })
//        
//        editAction.backgroundColor = .systemBlue
//        
//        return [deleteAction, editAction]
//    }

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
    
}

