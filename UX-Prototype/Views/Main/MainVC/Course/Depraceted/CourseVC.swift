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
    
    var options: [String] = []
    var selectedOption: String = "All"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CourseTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CourseTVC")
        
        tableView.register(UINib(nibName: "CourseSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        tableView.delegate = self
        tableView.dataSource = self

        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let defualt = UserDefaults.standard
        self.selectedOption = defualt.string(forKey: "SemesterSort")  ?? "All"

        fetchData(option: self.selectedOption)
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), menu: createAddMenu())
        navigationItem.rightBarButtonItem = addButton
        
//        let sortButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), menu: createOptionMenu())
//        navigationItem.leftBarButtonItem = sortButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData(option: self.selectedOption)
        
//        let sortButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), menu: createOptionMenu())
//        navigationItem.leftBarButtonItem = sortButton
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let defualt = UserDefaults.standard
        defualt.set(self.selectedOption, forKey: "SemesterSort")
    }
}

// MARK: - Component Init
extension CourseVC {
    func createAddMenu() -> UIMenu {
        let addCourseAction = UIAction(title: "Course", image: UIImage(systemName: "plus")) { _ in
            // Handle the "Course" action (e.g., add a new course)
            self.addCourse()
        }
        
        let addSemesterAction = UIAction(title: "Semester", image: UIImage(systemName: "plus")) { _ in
            // Handle the "Semester" action (e.g., add a new semester)
            self.addSemester()
        }
        
        return UIMenu(children: [addCourseAction, addSemesterAction])
    }
    
    func createOptionMenu() -> UIMenu {
        var actions: [UIAction] = []
        
        for option in options
        {
            let action = UIAction(title: option) { _ in
                // Handle the "Course" action (e.g., add a new course)
                self.fetchData(option: option)
            }
            
            if(option == selectedOption) {
                action.image = UIImage(systemName: "checkmark")
            }
            
            actions.append(action)
        }
        
        return UIMenu(children: actions)
    }
}

// MARK: - Actions
extension CourseVC {
    @objc func addCourse() {
        var courseView = CourseView()
        courseView.delegate = self
        let hostingController = UIHostingController(rootView: courseView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
    @objc func addSemester() {
        var semesterView = SemesterView()
        semesterView.delegate = self
        let hostingController = UIHostingController(rootView: semesterView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
//    @objc func sortBy(option : String) {
//        self.selectedOption = option
//        fetchData(option: self.selectedOption)
//    }
}

// MARK: - Delegate
extension CourseVC : DisappearingViewDelegate, EditSemesterDelegate, SemesterDelegate {
    func pushSemester(with semester: Semester?) {
        let vc = UIHostingController(rootView: SemesterInfoView(semester: semester))
        vc.title = "Semester Info"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushEdit(with semester: Semester?) {
        
        var semesterView = SemesterView(with: semester)
        semesterView.delegate = self
        let hostingController = UIHostingController(rootView: semesterView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
    func viewWillDisappear() {
        fetchData(option: self.selectedOption)
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: createOptionMenu())
        navigationItem.leftBarButtonItem = sortButton
    }
    
    
    
}

// MARK: - Data Fetching
extension CourseVC {
    func fetchData(option: String) {
        fetchSemesters()
        initOption()
        
        
        if(self.options.contains(option)) {
            self.selectedOption = option
        } else {
            self.selectedOption = "All"
        }
        
        if(self.selectedOption == "All") {
            
            fetchCourses()
            fetchCoursesBySemester()
        } else {
            fetchSemester(semester: self.selectedOption)
        }
        
        tableView.reloadData()
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: createOptionMenu())
        navigationItem.leftBarButtonItem = sortButton
    }
    
    func fetchSemester(semester: String) {
        let semester = CoreDataManager.shared.fetch(entity: Semester.self, with: ["name": semester as Any])?.first
        
        if(semester == nil){
            return
        }
        
        let all_courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        var courses = all_courses.filter { $0.semester == semester }
        courses.sort {$0.name ?? "" > $1.name ?? ""}
        
        self.courses = courses
        self.semesters = [semester!]
        self.coursesBySemesters = [courses]
        
        tableView.reloadData()
    }
    
    func initOption() {
        self.options = self.semesters.map { return $0.name ?? "" }
        self.options.insert("All", at: 0)
    }
    
    private func fetchCourses() {
        courses = []
        courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []
        courses.sort {$0.name ?? "" > $1.name ?? ""}
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
        return 94
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < semesters.count
        {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? CourseSectionHeaderView {

                headerView.editdelegate = self
                headerView.semesterdelegetae = self
                
                let semester = semesters[section]
                
                headerView.semesterName.titleLabel?.text = semester.name?.uppercased()
                headerView.semester = semester
                
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
            
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(name)?") { didConfirmDelete in
                
                if didConfirmDelete {
                    self.coursesBySemesters[section].remove(at: row)
                    self.tableView.reloadData()
                    
                    CoreDataManager.shared.delete(course)
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let resourcesAction = UIContextualAction(style: .normal, title: "Resources") {  (contextualAction, view, boolValue) in
            let vc = self.storyboard?.instantiateViewController(identifier: "CourseInfoVC") as! CourseInfoVC

            vc.course = self.coursesBySemesters[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        resourcesAction.backgroundColor = .systemOrange
        resourcesAction.image = UIImage(systemName: "folder.fill")
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, resourcesAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = indexPath.row
        let section = indexPath.section
        
        let course = self.coursesBySemesters[section][row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            // Get the name of the course
            
            var courseView = CourseView(with: course)
            courseView.delegate = self
            let hostingController = UIHostingController(rootView: courseView)

            // Present the SwiftUI view
            self.present(hostingController, animated: true, completion: nil)
        }

        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemBlue
        
//        let semesterAction = UIContextualAction(style: .normal, title: "Semester") { (contextualAction, view, boolValue) in
//            let semester = course.semester
//            
//            let vc = UIHostingController(rootView: SemesterInfoView(semester: semester))
//            vc.title = "Semester Info"
//            self.navigationController?.pushViewController(vc, animated: true)
//        
//        }
        
//        semesterAction.backgroundColor = .systemPink
//        semesterAction.image = UIImage(systemName: "book.fill")
        
        let actions = [editAction]
//        if course.semester != nil {
//            actions.append(semesterAction)
//        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        
        return swipeActions
    }
}

