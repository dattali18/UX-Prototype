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
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        // creating a user (in ther future we will store it)
        let name = userNameTxtField.text
        let email = emailTxtField.text
        let password = passTxtField.text
        
        if(name != nil && email != nil && password != nil && password == confPassTxtFiled.text) {
            UserLogin.shared.signUp(Name: name!, Email: email!, Password: password!)
            
            
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(CustomTB)
        }
        
    }
    
    
    @IBAction func signInLink(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
