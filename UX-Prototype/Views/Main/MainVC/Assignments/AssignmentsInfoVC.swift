//
//  AssignmentsInfo.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/15/23.
//

import UIKit
import SwiftUI

import EventKit
import CalendarKit
import EventKitUI

class AssignmentsInfoVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var eventStore = EKEventStore()
        
    var sections: [[Assignment]] = []
    var assignemnts: [Assignment] = []
    var course: Course?
    var type: String = "Assignment"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let nib = UINib(nibName: "AssignmentTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AssignmentTVC")
        
        
        fetchData()
        
        if(self.assignemnts.isEmpty == false)
        {
            type = self.assignemnts[0].type ?? type
        }
        
        if(course != nil) {
            self.title = "\(course!.name!) - \(type)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }

}

// MARK: - Delegate
extension AssignmentsInfoVC: DisappearingAssignmentViewDelegate {
    func viewWillDisappear(assignment: Assignment?, open: Bool) {
        fetchData()
        
        if(assignment == nil) {
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

// MARK: - Table View
extension AssignmentsInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTVC", for: indexPath) as! AssignmentTVC
        
        let row = indexPath.row
        let section = indexPath.section
        
        let assignment = self.sections[section][row]
        
        cell.nameLabel.text = assignment.name
        
        if  assignment.descriptions == "" || assignment.descriptions == nil {
            cell.descriptionLabel.text = "No Description"
        } else {
            cell.descriptionLabel.text = assignment.descriptions
        }
        
        // Your Date object
        
        let date = assignment.due
        
        if(date == nil) {
            cell.dateLabel.text = "No Date"
        } else {
            
            // Create a DateFormatter
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "E d MMM"
            
            // Convert the Date to a String
            let dateString = dateFormatter.string(from: date!)
            cell.dateLabel.text = dateString
        }
        
        let url = assignment.url
        
        if(url == "" || url == nil) {
            cell.urlLabel.text = "No URL"
        } else {
            cell.urlLabel.text = url
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Completed"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // Adjust the section header height as needed
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    // MARK: - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let row = indexPath.row
            let section = indexPath.section
            
            let assignment = self.sections[section][row]
            
//            CourseDataManager.shared.deleteCourse(withName: name)
            self.showDeleteConfirmationAlert(message: "Are you sure you want to delete this assignemnt?") { didConfirmDelete in
                if didConfirmDelete {
                    
                    self.sections[section].remove(at: row)
                    self.tableView.reloadData()
                    
                    CoreDataManager.shared.delete(assignment)
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") {  (contextualAction, view, boolValue) in
            let row = indexPath.row
            let section = indexPath.section
            
            let assignment = self.sections[section][row]
            
            assignment.done = !assignment.done
            
            self.fetchData()
        }
        
        let row = indexPath.row
        let section = indexPath.section
        
        let assignment = self.sections[section][row]
        let done = assignment.done
        if done {
            doneAction.title = "Undone"
            doneAction.backgroundColor = .systemRed
            doneAction.image = UIImage(systemName: "x.circle.fill")
        } else {
            doneAction.backgroundColor = .systemGreen
            doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [doneAction])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        let assignment = self.sections[section][row]
        
        var assignmentView = AssignmentView(with: assignment)
        // implementing the obeserver pattern
        assignmentView.delegate = self
        let hostingController = UIHostingController(rootView: assignmentView)

        // Present the SwiftUI view
        present(hostingController, animated: true, completion: nil)
    }
    
}
// MARK: - Data Fetching
extension AssignmentsInfoVC {
    func fetchData() {
        self.assignemnts = []
        
        if(self.course == nil) {
            self.tableView.reloadData()
            return
        }
        
        self.assignemnts = CoreDataManager.shared.fetch(entity: Assignment.self) ?? []
        self.assignemnts = self.assignemnts.filter { $0.course == self.course && $0.type == self.type }
        self.assignemnts = self.assignemnts.sorted { $0.name ?? "" > $1.name ?? "" }
        
        let done = self.assignemnts.filter { $0.done == true }
        let noDone = self.assignemnts.filter { $0.done == false }
        
        self.sections = [noDone, done]
        
        self.tableView.reloadData()
    }
}

extension AssignmentsInfoVC : EKEventEditViewDelegate {
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
