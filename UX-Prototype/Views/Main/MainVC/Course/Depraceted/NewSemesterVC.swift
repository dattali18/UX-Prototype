//
//  NewSemesterVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/5/23.
//

import UIKit

class NewSemesterVC: UIViewController {
    @IBOutlet weak var semesterPicker: UIPickerView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    // Define the data source for the picker view
    let semesters: [SemesterEnum] = [.spring, .summer, .fall]
    var selectedSemester: SemesterEnum = .spring
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.title = "Start New Semester"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self
    }

    @IBAction func startNewSemester(_ sender: Any){
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
        
        let name =  "\(type) \(yearString)"
        
        let res = CoreDataManager.shared.create(entity: Semester.self, with: ["type": type, "start": startDate, "end": endDate, "name": name])
        
        if (res != nil) {
            navigationController?.popToRootViewController(animated: true)
        } else {
            // pop up the course with exacte same number allready exist
            self.showErrorAlert(message: "Something went wront")
        }
    }
}

// MARK: - Picker View
extension NewSemesterVC: UIPickerViewDataSource, UIPickerViewDelegate {
    // Implement UIPickerViewDataSource methods
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Number of components in the picker view (1 for a single column)
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return semesters.count
        }
        
        // Implement UIPickerViewDelegate method to display text in the picker view
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return semesters[row].description // Display the description of the Semester enum
        }
        
        // Handle the selected row
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            self.selectedSemester = semesters[row]
        }
}
