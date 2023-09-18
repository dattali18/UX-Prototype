//
//  addCourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/18/23.
//

import UIKit

class addCourseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
        self.title = "Add Course"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
