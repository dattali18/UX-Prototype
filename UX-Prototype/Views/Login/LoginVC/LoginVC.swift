//
//  LoginVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        // check if the user is the user we have created
    }
    
}

