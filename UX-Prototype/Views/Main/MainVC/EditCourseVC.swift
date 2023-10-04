//
//  EditCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import UIKit

class editCourseVC: UIViewController {
    var courseNameTxt: String? = ""
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var courseCredits: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let course = CourseDataManager.shared.fetchCourse(withName: courseNameTxt)
        
        
//        self.title = course?.name ?? ""
        self.title = courseNameTxt
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
    }
    
    // TODO: add the views inorder to update the course and make the update using core data
   
    @IBAction func updateBtn(_ sender: Any) {
        print("hello")
    }
}
