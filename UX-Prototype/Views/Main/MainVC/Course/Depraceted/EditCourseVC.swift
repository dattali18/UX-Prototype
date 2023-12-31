//
//  EditCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import UIKit
import CoreData

class EditCourseVC: UIViewController {
    var courseNameTxt: String? = ""
    var course: Course?
    var selectedSemester: Semester?
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseCredits: UITextField!
    @IBOutlet weak var semesterPicker: UIPickerView!
    
    // Define the data source for the picker view
    var semesters: [Semester]? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self

        self.course = CoreDataManager.shared.fetch(entity: Course.self, with: ["name": courseNameTxt as Any])?.first
        self.semesters = CoreDataManager.shared.fetch(entity: Semester.self)
        
        self.title = courseNameTxt
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
        
        let name: String = self.course?.name ?? ""
        let number: Int = Int(self.course?.number ?? 0)
        let credits: Float = self.course?.credits ?? 0.0
        let semester: Semester? = self.course?.semester
        
        courseName.text = name
        courseNumber.text = "\(number)"
        courseCredits.text = "\(credits)"
        
        if (semesters != nil && semester != nil){
            self.selectedSemester = semesters?.first
            if let row = semesters?.firstIndex(of: semester!) {
                semesterPicker.selectRow(row, inComponent: 0, animated: false)
                self.selectedSemester = semesters?[row]
           }
        } else if(semester == nil) {
            return
        }
        
    }
   
    @IBAction func updateBtn(_ sender: Any){
      if(courseName.text == "" || courseNumber.text == "" || courseCredits.text == "") {
        self.showErrorAlert(message: "Please fill all field before saving")
        return
      } else {
          let name: String    = courseName.text ?? ""
          let credits: Float   = Float(courseCredits.text ?? "0.0") ?? 0
          let number: Int32   = self.course?.number ?? 0
          let semester: Semester? = self.selectedSemester
          
          
          let date = semester?.start ?? Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy"
          let yearString = dateFormatter.string(from: date)
          
          let nameRepresentation =  "\(semester?.type ?? "") \(yearString)"

          // Fetch the Semester object from the persistent store
          let sem = CoreDataManager.shared.fetch(entity: Semester.self, with: ["name": nameRepresentation])?.first
          

            // Check if the Semester object exists in the persistent store
            if sem == nil {
                  // The Semester object does not exist
                  self.showErrorAlert(message: "The selected semester does not exist.")
                  return
            }

          // Update the Course object
          if(self.course != nil) {
              let res = CoreDataManager.shared.update(entity: self.course!, with: ["name": name, "number": number, "credits": credits, "semester": sem as Any])
              
              if(res != nil) {
                  navigationController?.popToRootViewController(animated: true)
              } else {
                  self.showErrorAlert(message: "There was a problem updating the course info.")
              }
          }

      }
    }
}


// MARK: - Picker View
extension EditCourseVC: UIPickerViewDataSource, UIPickerViewDelegate {
    // Implement UIPickerViewDataSource methods
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Number of components in the picker view (1 for a single column)
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return semesters?.count ?? 0
        }
        
        // Implement UIPickerViewDelegate method to display text in the picker view
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let semester: Semester? = semesters?[row]
            
            return  semester?.name ?? "" // Display the description of the Semester enum
        }
        
        // Handle the selected row
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.selectedSemester = semesters?[row]
            
        }
}
