//
//  AssignmentsVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class AssignmentsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var assignments: [Assignment] = []
    var courses: [Course] = []
    var sections: [[(Course , [Assignment])]] = []
    
    var sectionName: [String] = ["Homework", "Midterm", "Final"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AssignmentsTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AssignmentsTVC")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.title = "Assignments"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }

}


extension AssignmentsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentsTVC", for: indexPath) as! AssignmentsListTVC
        
        let (course, assignments) = self.sections[indexPath.section][indexPath.row]
        
        cell.courseLabel.text = course.name
        cell.numberLabel.text = "\(assignments.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionName[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
            let section = indexPath.section
            
            let (course, assignments) = self.sections[section][row]
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the course \(course.name ?? "")?") { didConfirmDelete in
                if didConfirmDelete {
                    self.sections[section].remove(at: row)
                    self.tableView.reloadData()
                    
                    for assignment in assignments {
                        CoreDataManager.shared.delete(assignment)
                    }
                    
                }
            }
        }
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        let vc = self.storyboard?.instantiateViewController(identifier: "AssignmentsInfo") as! AssignmentsInfo
        
        let (course, assignments) = self.sections[section][row]
        
        vc.assignemnts = assignments
        vc.course = course

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AssignmentsVC {
    
    // MARK: - Data Fetching
    
    /// Fetches and organizes the assignment data and reloads the table view.
    func fetchData() {
        // Initialize arrays
        self.assignments = []
        self.sections = []
        self.courses = []
        
        // Fetch assignments from the data manager
        self.assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        
        // Sort assignments by type (Homework, Midterm, Final)
        let (homework, midterm, final) = sortAssignmentsByType(self.assignments)
        
    
        // Group assignments by course
        self.sections = [
            sortAssignmentsByCourse(homework),
            sortAssignmentsByCourse(midterm),
            sortAssignmentsByCourse(final)
        ]
        
        
        
        // Reload table view data
        self.tableView.reloadData()
    }
    
    // MARK: - Assignment Sorting
    
    /// Sorts assignments into three lists based on their type.
    ///
    /// - Parameters:
    ///   - assignments: An array of assignments to be sorted.
    ///
    /// - Returns: A tuple containing three arrays: Homework assignments, Midterm assignments, and Final assignments.
    func sortAssignmentsByType(_ assignments: [Assignment]) -> ([Assignment], [Assignment], [Assignment]) {
        var homeworkAssignments = [Assignment]()
        var midtermAssignments = [Assignment]()
        var finalAssignments = [Assignment]()

        for assignment in assignments {
            switch assignment.type {
            case "Homework":
                homeworkAssignments.append(assignment)
            case "Midterm":
                midtermAssignments.append(assignment)
            case "Final":
                finalAssignments.append(assignment)
            default:
                // Handle unknown assignment types here.
                break
            }
        }

        return (homeworkAssignments, midtermAssignments, finalAssignments)
    }
    
    /// Sorts assignments by their associated course.
    ///
    /// - Parameters:
    ///   - assignments: An array of assignments to be grouped by course.
    ///
    /// - Returns: An array of tuples, each containing a course and its associated assignments.
    func sortAssignmentsByCourse(_ assignments: [Assignment]) -> [(Course, [Assignment])] {
        var courseAssignmentMap = [Course: [Assignment]]()

        for assignment in assignments {
            if let course = assignment.course {
                if courseAssignmentMap[course] == nil {
                    courseAssignmentMap[course] = [assignment]
                } else {
                    courseAssignmentMap[course]?.append(assignment)
                }
            }
        }

        // Filter out courses with no assignments
        let courseAssignmentPairs = courseAssignmentMap
            .filter { !$0.value.isEmpty }
            .map { ($0.key, $0.value) }

        return courseAssignmentPairs
    }
    
    // Add more functions as needed for further functionality.
}
