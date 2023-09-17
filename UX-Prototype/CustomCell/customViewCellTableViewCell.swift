//
//  customViewCellTableViewCell.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class customViewCellTableViewCell:
    UITableViewCell {
    
    @IBOutlet weak var name: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didClickNext(_ sender: Any) {
    }
}
