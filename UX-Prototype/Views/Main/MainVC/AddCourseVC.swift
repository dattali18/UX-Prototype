//
//  addCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/18/23.
//

import UIKit

class addCourseVC: UIViewController {
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseCredits: UITextField!
    @IBOutlet weak var semesterPicker: UIPickerView!
    
    // Define the data source for the picker view
    let semesters: [SemesterEnum] = [.spring, .summer, .fall]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self

        // Do any additional setup after loading the view.
        self.title = "Add Course"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func addCourseBtn(_ sender: Any) {
        
        if(courseName.text == "" || courseNumber.text == "" || courseCredits.text == "") {
            self.showErrorAlert(message: "Please fill all info in the text field.")
        } else {
            let name: String       = courseName.text ?? ""
            let number: Int32      = Int32(courseNumber.text ?? "0") ?? 0
            let credits: Float     = Float(courseCredits.text ?? "0.0") ?? 0
            
            let res = CoreDataManager.shared.create(entity: Course.self, with: ["name": name, "number": number, "credits": credits])
            if (res != nil) {
                navigationController?.popToRootViewController(animated: true)
            } else {
                // pop up the course with exacte same number allready exist
                self.showErrorAlert(message: "Error a course with the same id allready exist.")
            }

            
        }
    }
    
}

extension addCourseVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedSemester = semesters[row]
            
            print("Selected Semester: \(selectedSemester)")
        }
}
