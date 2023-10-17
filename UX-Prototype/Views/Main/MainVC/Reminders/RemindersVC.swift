//
//  RemindersVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class RemindersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Reminders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .secondarySystemBackground
    }
}
