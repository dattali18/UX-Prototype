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
//        self.layer.cornerRadius = 5
        courseName.lineBreakMode = .byTruncatingTail
//        courseName.numberOfLines = 0
//        courseName.adjustsFontForContentSizeCategory = true
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didTouchButton(_ sender: Any) {
        
    }
}
