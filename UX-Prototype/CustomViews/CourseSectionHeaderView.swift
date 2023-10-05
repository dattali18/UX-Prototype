//
//  CourseSectionHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/6/23.
//

import UIKit

class CourseSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var semesterNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var semester: Semester?
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.addTarget(self, action: #selector(editButtonPresssed), for: .touchUpInside)
    }

    @objc func editButtonPresssed() {
        // Navigate to the editSemesterVC class.
        guard let navigationController = navigationController else { return }
        guard let storyboard = storyboard else { return }

        let editSemesterVC = storyboard.instantiateViewController(identifier: "EditSemesterVC") as! EditSemesterVC
        editSemesterVC.semester = self.semester

        navigationController.pushViewController(editSemesterVC, animated: true)
    }
}
