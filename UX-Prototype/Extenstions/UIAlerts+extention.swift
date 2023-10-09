//
//  Alerts.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInfoAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteConfirmationAlert(message: String, completion: @escaping (Bool) -> Void) {
      let alert = UIAlertController(title: "Delete Confirmation", message: message, preferredStyle: .alert)

      // Add a Confirm button to the alert
      let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
        completion(true)
      }
      alert.addAction(confirmAction)

      // Add a Cancel button to the alert
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        completion(false)
      }
      alert.addAction(cancelAction)

      // Present the alert
      self.present(alert, animated: true, completion: nil)
    }
}
