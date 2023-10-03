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
            let number: Int16      = Int16(courseNumber.text ?? "0") ?? 0
            let credits: Float     = Float(courseCredits.text ?? "0.0") ?? 0
            
            let managedObjectContext = CoreDataStack.shared.managedObjectContext
            // Creating a new Course
            let newCourse = Course(context: managedObjectContext)
            
            newCourse.name = name
            newCourse.number = number
            newCourse.credits = credits


            // Save changes to Core Data
            do {
                try managedObjectContext.save()
                print("Data saved successfully!")
            } catch {
                print("Error saving data: \(error.localizedDescription)")
            }
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
