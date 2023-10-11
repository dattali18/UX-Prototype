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
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func editButton(_ sender: Any) {
        // Navigate to the editSemesterVC class.
        guard let navigationController = navigationController else { return }
        guard let storyboard = storyboard else { return }

        let addResource = storyboard.instantiateViewController(identifier: "AddResourcesVC") as! AddResourcesVC
        addResource.resource = self.resource
        addResource.mode = .edit

        navigationController.pushViewController(addResource, animated: true)
    }
}
