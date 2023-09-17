//
//  SignUpVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var confPassTxtFiled: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        // creating a user (in ther future we will store it)
        
    }
    
    
}
