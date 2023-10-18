//
//  CourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import CoreData
import SwiftUI

class CourseVC: UIViewController {
    
    var courses: [Course] = []
    var semesters: [Semester] = []
    var coursesBySemesters: [[Course]] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CourseTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CourseTVC")
        
        tableView.delegate = self
        tableView.dataSource = self

        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .secondarySystemBackground
        
        tableView.register(UINib(nibName: "CourseSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")

        //
        //        let addSemester = UIBarButtonItem(title: "Add Semester", style: .plain, target: self, action: #selector(addSemester))
        //
        //        navigationItem.rightBarButtonItem = addSemester
        //        navigationItem.leftBarButtonItem = addCourse
        
        let addCourseAction = UIAction(title: "Course", image: UIImage(systemName: "plus")) { _ in
            // Handle the "Course" action (e.g., add a new course)
            self.addCourse()
        }
        
        
        let addSemesterAction = UIAction(title: "Semester", image: UIImage(systemName: "plus")) { _ in
            // Handle the "Semester" action (e.g., add a new semester)
            self.addSemester()
        }
        
        let menu = UIMenu(children: [addCourseAction, addSemesterAction])
        
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), menu: menu)
        navigationItem.rightBarButtonItem = addButton
        
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData()
    }
    
    
    @objc func addCourse() {
        var courseView = CourseView()
        courseView.delegate = self
        let hostingController = UIHostingController(rootView: courseView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCourseVC") as! AddCourseVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addSemester() {
        var semesterView = SemesterView()
        semesterView.delegate = self
        let hostingController = UIHostingController(rootView: semesterView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "NewSemesterVC") as! NewSemesterVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Delegate
extension CourseVC : DisappearingViewDelegate, EditSemesterDelegate {
    func pushEdit(with semester: Semester?) {
        
        var semesterView = SemesterView(with: semester)
        semesterView.delegate = self
        let hostingController = UIHostingController(rootView: semesterView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
    func viewWillDisappear() {
        fetchData()
    }
    
    
}

// MARK: - Data Fetching
extension CourseVC {
    func fetchData() {
        fetchCourses()
        fetchSemesters()
        fetchCoursesBySemester()
        
        tableView.reloadData()
    }
    
    private func fetchCourses() {
        courses = []
        courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
       }

    private func fetchSemesters() {
        self.semesters = []
        // Get all of the semesters from Core Data.
        var semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []

        // Sort the semesters by the start date.
        semesters.sort { $0.start ?? Date() > $1.start ?? Date() }

        // Assign the sorted semesters to the semesters property.
        self.semesters = semesters
    }
    
    private func fetchCoursesBySemester(){
        coursesBySemesters = []
        
        for semester in self.semesters {
            let coursesBySemester = self.courses.filter { $0.semester == semester }
            self.coursesBySemesters.append(coursesBySemester)
        }
        
        // Add all courses without semester to the end of the list.
        let coursesWithoutSemester = self.courses.filter { $0.semester == nil }
        if !coursesWithoutSemester.isEmpty {
            self.coursesBySemesters.append(coursesWithoutSemester)
        }
        
    }
}


// MARK: - Table View
extension CourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CourseInfoVC") as! CourseInfoVC

        vc.course = self.coursesBySemesters[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.coursesBySemesters.isEmpty || self.courses.count < section) {
            return 0
        }
        return self.coursesBySemesters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTVC", for: indexPath) as! CourseTVC
        
        let course = self.coursesBySemesters[indexPath.section][indexPath.row]
        
        cell.nameLabel.text     = course.name
        cell.creditLabel.text   = "\(course.credits)"
        cell.numberLabel.text   = "\(course.number)"

        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.coursesBySemesters.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < semesters.count
        {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? CourseSectionHeaderView {
                
                headerView.semesterNameLabel?.text = semesters[section].name?.uppercased()
                headerView.semester = semesters[section]
                headerView.delegate = self
//                headerView.navigationController = self.navigationController
//                headerView.storyboard = self.storyboard
                
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
            let section = indexPath.section
            
            let course = self.coursesBySemesters[section][row]
            let name = course.name ?? ""
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(name)?") { didConfirmDelete in
                
                if didConfirmDelete {
                    self.coursesBySemesters[section].remove(at: row)
                    self.tableView.reloadData()
                    
                    CoreDataManager.shared.delete(course)
                }
            }
        }
        
        let editAction  = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            // Get the name of the course
            let row = indexPath.row
            let section = indexPath.section
            
            let course = self.coursesBySemesters[section][row]
            
            var courseView = CourseView(with: course)
            courseView.delegate = self
            let hostingController = UIHostingController(rootView: courseView)

            // Present the SwiftUI view
            self.present(hostingController, animated: true, completion: nil)
            
//            let vc = self.storyboard?.instantiateViewController(identifier: "editCourseVC") as! EditCourseVC
//            vc.courseNameTxt = name
//
//            self.navigationController?.pushViewController(vc, animated: true)
        }

        editAction.backgroundColor = .systemBlue
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

        return swipeActions
    }
}

