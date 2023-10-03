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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
        self.title = "Add Course"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func addCourseBtn(_ sender: Any) {
        
        if(courseName.text == "" || courseNumber.text == "" || courseCredits.text == "") {
            return
        } else {
            let name: String       = courseName.text ?? ""
            let number: Int32      = Int32(courseNumber.text ?? "0") ?? 0
            let credits: Float     = Float(courseCredits.text ?? "0.0") ?? 0
            
            if addNewCourse(name: name, number: number, credits: credits) {
                navigationController?.popToRootViewController(animated: true)
            } else {
                // pop up the course with exacte same number allready exist
            }

            
        }
    }
    
}
