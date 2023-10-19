//
//  ResourcesSectionHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/10/23.
//

import UIKit

class ResourcesSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    
    @IBOutlet weak var arrowButton: UIButton!
    
    var resource: Resource?
    var course: Course?
//    var navigationController: UINavigationController?
//    var storyboard: UIStoryboard?
    
    
    weak var delegate: EditResourceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func editButton(_ sender: Any) {
        delegate?.pushEdit(resource: resource, course: course)
        // Navigate to the editSemesterVC class.
//        guard let navigationController = navigationController else { return }
//        guard let storyboard = storyboard else { return }
//
//        let addResource = storyboard.instantiateViewController(identifier: "AddResourcesVC") as! AddResourcesVC
//        addResource.resource = self.resource
//        addResource.mode = .edit
//        addResource.course = self.course
//
//        navigationController.pushViewController(addResource, animated: true)
    }
}
