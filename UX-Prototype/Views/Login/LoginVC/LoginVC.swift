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
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = .secondarySystemBackground
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if(UserLogin.shared.asSignUp()) {
            let user :User = UserLogin.shared.loadUser()
            
            userNameTxtField.text = user.name
            emailTxtField.text = user.email
            passTxtField.text = user.password
        }

    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        // check if the user is the user we have created
        let name = userNameTxtField.text
        let email = emailTxtField.text
        let password = passTxtField.text
        
        if(name != nil && email != nil && password != nil) {
            if(UserLogin.shared.signIn(Name: name!, Email: email!, Password: password!)) {
                
                let storyboard = UIStoryboard (name: "Main", bundle: nil)
                let CustomTB = storyboard.instantiateViewController(identifier: "MainTB") as! MainTabBarVC
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(CustomTB)
                
            }
        }
        
    }
    
}

