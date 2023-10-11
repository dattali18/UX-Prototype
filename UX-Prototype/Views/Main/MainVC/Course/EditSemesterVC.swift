//
//  EditSemesterVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/6/23.
//

import UIKit

class EditSemesterVC: UIViewController {
    @IBOutlet weak var semesterPicker: UIPickerView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    // Define the data source for the picker view
    let semesters: [SemesterEnum] = [.spring, .summer, .fall]
    var selectedSemester: SemesterEnum = .spring
    var semester: Semester?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.title = "Edit Semester"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self
        
        // setting the values
        if(semester != nil) {
            self.title = "Edit - \(semester!.str!)"
            let row = semesterFromString(str: semester!.str!)?.num ?? 0
            semesterPicker.selectRow(row, inComponent: 0, animated: false)
            
            startDatePicker.date = semester?.start! ?? Date()
            endDatePicker.date = semester?.end! ?? Date()
        }
        
        // Add a delete button to the navigation bar
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSemester))
        self.navigationItem.rightBarButtonItem = deleteButton
        // Set the font of the delete button to red
//        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.tintColor = .systemRed

    }
    

    @IBAction func editSemester(_ sender: Any){
        // Get the start and end dates from the date pickers
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        // Check if the end date is after the start date
          if endDate < startDate {
            // Show an alert to the user
            self.showErrorAlert(message: "The end date must be after the start date.")
            return
          }
        
        let type = self.selectedSemester.description
        
        let date = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        
        let str =  "\(type) \(yearString)"
        
        let res = CoreDataManager.shared.update(entity: self.semester!, with: ["type": type, "start": startDate, "end": endDate, "str": str])
        
        if (res != nil) {
            navigationController?.popToRootViewController(animated: true)
        } else {
            // pop up the course with exacte same number allready exist
            self.showErrorAlert(message: "Something went wront")
        }
    }
    
    @objc func deleteSemester() {
        // Delete the semester from the database
        
        self.showDeleteConfirmationAlert(message: "Are you sure you want to delete the semester \(self.semester?.str! ?? "")?") { didConfirmDelete in
            
            if didConfirmDelete {
                
                CoreDataManager.shared.delete(entity: Semester.self, with: ["str": self.semester?.str! as Any])
                
                // Navigate back to the root view controller
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        

    }
    
}

extension EditSemesterVC: UIPickerViewDataSource, UIPickerViewDelegate {
    // Implement UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Number of components in the picker view (1 for a single column)
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.semesters.count
    }
        
        // Implement UIPickerViewDelegate method to display text in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.semesters[row].description // Display the description of the Semester enum
    }
        
        // Handle the selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.selectedSemester = self.semesters[row]
    }
}
