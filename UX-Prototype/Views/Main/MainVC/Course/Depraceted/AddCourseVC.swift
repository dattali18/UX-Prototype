//
//  AddCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/18/23.
//

import UIKit

class AddCourseVC: UIViewController {
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseCredits: UITextField!
    @IBOutlet weak var semesterPicker: UIPickerView!
    
    // Define the data source for the picker view
    var semesters: [Semester]? = nil;
    var selectedSemester: Semester?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self

        // Do any additional setup after loading the view.
        self.title = "Add Course"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.semesters = CoreDataManager.shared.fetch(entity: Semester.self)
        
        if(self.semesters != nil) {
            if(!self.semesters!.isEmpty) {
                self.selectedSemester = self.semesters?[0]
            }
        }
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    @IBAction func addCourseBtn(_ sender: Any) {
        
        if(courseName.text == "" || courseNumber.text == "" || courseCredits.text == "") {
            self.showErrorAlert(message: "Please fill all info in the text field.")
        } else {
            let name: String       = courseName.text ?? ""
            let number: Int32      = Int32(courseNumber.text ?? "0") ?? 0
            let credits: Float     = Float(courseCredits.text ?? "0.0") ?? 0
            let semester: Semester? = self.selectedSemester
            
            let res: Course?
            
            if(semester == nil) {
                res = CoreDataManager.shared.create(entity: Course.self, with: ["name": name, "number": number, "credits": credits])
            } else {
                res = CoreDataManager.shared.create(entity: Course.self, with: ["name": name, "number": number, "credits": credits, "semester": semester as Any])
            }
            
           
            
            if (res != nil) {
                navigationController?.popToRootViewController(animated: true)
            } else {
                // pop up the course with exacte same number allready exist
                self.showErrorAlert(message: "Something went wront with creating new Course.")
            }

            
        }
    }
    
}

// MARK: - Picker View
extension AddCourseVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
            
            guard let date = semester?.start else { return "" }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let yearString = dateFormatter.string(from: date)
            
            return  "\(semester?.type ?? "")  \(yearString)" // Display the description of the Semester enum
        }
        
        // Handle the selected row
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.selectedSemester = semesters?[row]
        }
}
