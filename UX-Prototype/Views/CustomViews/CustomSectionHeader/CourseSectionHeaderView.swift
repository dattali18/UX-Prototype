//
//  CourseSectionHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/6/23.
//

import UIKit

class CourseSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var semesterName: UIButton!
    
    var semester: Semester?
    
    weak var editdelegate: EditSemesterDelegate?
    weak var semesterdelegetae: SemesterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.addTarget(self, action: #selector(editButtonPresssed), for: .touchUpInside)
        semesterName.addTarget(self, action: #selector(nameButtonPressed), for: .touchUpInside)
    }

    @objc func editButtonPresssed() {
        editdelegate?.pushEdit(with: semester)
    }
    
    @objc func nameButtonPressed() {
        semesterdelegetae?.pushSemester(with: semester)
    }
}
