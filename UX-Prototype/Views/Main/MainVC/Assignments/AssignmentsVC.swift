//
//  AssignmentsVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import SwiftUI

import EventKit
import CalendarKit
import EventKitUI

class AssignmentsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var eventStore = EKEventStore()
    
    var assignments: [Assignment] = []
    var courses: [Course] = []
    var sections: [[(Course , [Assignment])]] = []
    
    var sectionName: [String] = ["Homework", "Midterm", "Final", "Others"]
    
    var options: [String] = ["All", "Homework", "Midterm", "Final", "Others"]
    var selectedOption: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AssignmentsListTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AssignmentsListTVC")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.title = "Assignments"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .secondarySystemBackground
        
        let defualt = UserDefaults.standard
        self.selectedOption = defualt.string(forKey: "AssignmentSort")  ?? "All"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
//        let sortButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), menu: createOptionMenu())
//        navigationItem.leftBarButtonItem = sortButton
        
        fetchData(option: selectedOption)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData(option: selectedOption)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let defualt = UserDefaults.standard
        defualt.set(self.selectedOption, forKey: "AssignmentSort")
    }
    
    @objc func addButtonTapped() {
        var swiftUIView = AssignmentView()
        swiftUIView.delegate = self
        
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
}

// MARK: - Component Init
extension AssignmentsVC {
    func createOptionMenu() -> UIMenu {
        
        var actions: [UIAction] = []
        
        for option in options
        {
            let action = UIAction(title: option) { _ in
                // Handle the "Course" action (e.g., add a new course)
                self.fetchData(option: option)
                self.selectedOption = option
            }
            
            if(option == selectedOption) {
                action.image = UIImage(systemName: "checkmark")
            }
            
            actions.append(action)

        }
        
        return UIMenu(children: actions)
    }
}

// MARK: - Table View
extension AssignmentsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentsListTVC", for: indexPath) as! AssignmentsListTVC
        
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
        return 44
    }
    
    // MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
            let section = indexPath.section
            
            let (course, assignments) = self.sections[section][row]
            
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
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        let vc = self.storyboard?.instantiateViewController(identifier: "AssignmentsInfo") as! AssignmentsInfoVC
        
        let (course, _) = self.sections[section][row]
        
        vc.course = course
        vc.type = self.sectionName[section]

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Diasaprearing View Delegate
extension AssignmentsVC: DisappearingAssignmentViewDelegate {
    func viewWillDisappear(assignment: Assignment?, open: Bool) {
        fetchData(option: selectedOption)
        
        if(assignment == nil){
            return
        }
        
        if(open) {
            let date = assignment?.due ?? Date()
            let title = assignment?.name ?? ""
            
            let event = createNewEvent(at: date, title: title)
            presentEditingViewForEvent(event.ekEvent)
        }
    }
}
// MARK: - Data Fetching
extension AssignmentsVC {
    
    /// Fetches and organizes the assignment data and reloads the table view.
    func fetchData(option: String) {
        // Initialize arrays
        self.assignments = []
        self.sections = []
        self.courses = []
        
        // Fetch assignments from the data manager
        self.assignments = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        
        // Sort assignments by type (Homework, Midterm, Final)
        let (homework, midterm, final, others) = sortAssignmentsByType(self.assignments)
        
        // Group assignments by course
        switch option {
        case "All":
            self.sections = [
                sortAssignmentsByCourse(homework),
                sortAssignmentsByCourse(midterm),
                sortAssignmentsByCourse(final),
                sortAssignmentsByCourse(others)
            ]
            self.sectionName = ["Homework", "Midterm", "Final", "Others"]
        case "Homework":
            self.sections = [
                sortAssignmentsByCourse(homework)
            ]     
            self.sectionName = [option]
        case "Midterm":
            self.sections = [
                sortAssignmentsByCourse(midterm)
            ]   
            self.sectionName = [option]
        case "Final":
            self.sections = [
                sortAssignmentsByCourse(final)
            ]
            self.sectionName = [option]
        case "Others":
            self.sections = [
                sortAssignmentsByCourse(others)
            ]
            self.sectionName = [option]
        default:
            break
        }
      
        
        // Reload table view data
        self.tableView.reloadData()
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: createOptionMenu())
        navigationItem.leftBarButtonItem = sortButton
    }
    
    /// Sorts assignments into three lists based on their type.
    ///
    /// - Parameters:
    ///   - assignments: An array of assignments to be sorted.
    ///
    /// - Returns: A tuple containing three arrays: Homework assignments, Midterm assignments, and Final assignments.
    func sortAssignmentsByType(_ assignments: [Assignment]) -> ([Assignment], [Assignment], [Assignment], [Assignment]) {
        var homeworkAssignments = [Assignment]()
        var midtermAssignments = [Assignment]()
        var finalAssignments = [Assignment]()
        var othersAssignments = [Assignment]()

        for assignment in assignments {
            switch assignment.type {
            case "Homework":
                homeworkAssignments.append(assignment)
            case "Midterm":
                midtermAssignments.append(assignment)
            case "Final":
                finalAssignments.append(assignment)
            case "Others":
                othersAssignments.append(assignment)
            default:
                // Handle unknown assignment types here.
                break
            }
        }

        return (homeworkAssignments, midtermAssignments, finalAssignments, othersAssignments)
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
            .sorted { (pair1, pair2) in
                return pair1.0.name ?? "" < pair2.0.name ?? ""
            }
        
        return courseAssignmentPairs
    }
    
    
    // Add more functions as needed for further functionality.
    
    func printAssignments(_ assignments: [Assignment]) {
        if assignments.isEmpty {
            print("No assignments found.")
        } else {
            print("Assignments:")
            for assignment in assignments {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short

                let formattedDueDate = dateFormatter.string(from: assignment.due ?? Date())
                let courseName = assignment.course?.name ?? "Unknown Course"
                let assignmentType = assignment.type ?? "Unknown Type"

                print("Name: \(assignment.name ?? "Unnamed Assignment")")
                print("Description: \(assignment.descriptions ?? "No description")")
                print("Due Date: \(formattedDueDate)")
                print("Type: \(assignmentType)")
                print("Course: \(courseName)")
                print("------")
            }
        }
    }
}

extension AssignmentsVC : EKEventEditViewDelegate {
    private func createNewEvent(at date: Date, title: String) -> EKWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var components = DateComponents()
        components.hour = 1
        
        let calendar = Calendar.current
        
        let endDate = calendar.date(byAdding: components, to: date)
        
        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = title

        let newEKWrapper = EKWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true, completion: nil)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing = true
        navigationController?.pushViewController(eventController,
                                                 animated: true)
    }

    
    private func requestAccessToCalendar() {
        // Request access to the events
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            // Handle the response to the request.
            DispatchQueue.main.async {
                guard let self else { return }
                self.initializeStore()
            }
        }
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc(eventEditViewController:didCompleteWithAction:)
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
