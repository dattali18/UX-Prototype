//
//  customViewCellTableViewCell.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class customViewCellTableViewCell:
    UITableViewCell {
    
    @IBOutlet weak var courseName: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 5
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didTouchButton(_ sender: Any) {

    }
}
