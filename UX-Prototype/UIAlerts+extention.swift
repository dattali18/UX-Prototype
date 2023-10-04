//
//  Alerts.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
