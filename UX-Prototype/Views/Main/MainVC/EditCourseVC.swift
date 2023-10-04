//
//  EditCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import UIKit

class editCourseVC: UIViewController {
    var courseNameTxt: String? = ""
    var course: Course?
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseCredits: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        self.course = CourseDataManager.shared.fetchCourse(withName: courseNameTxt)
        
        
        self.title = courseNameTxt
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        let name: String = self.course?.name ?? ""
        let number: Int = Int(self.course?.number ?? 0)
        let credits: Float = self.course?.credits ?? 0.0
        
        courseName.text = name
        courseNumber.text = "\(number)"
        courseCredits.text = "\(credits)"
        
        
        
    }
    
    // TODO: add the views inorder to update the course and make the update using core data
   
    @IBAction func updateBtn(_ sender: Any) {
        if(courseName.text == "" || courseNumber.text == "" || courseCredits.text == "") {
            return
        } else {
            let name: String       = courseName.text ?? ""
            let credits: Float     = Float(courseCredits.text ?? "0.0") ?? 0
            
            CourseDataManager.shared.updateCourseWithID(self.course?.number ?? 0, newName: name, newCredits: credits)
            
            navigationController?.popToRootViewController(animated: true)
        
        }
    }
}
