//
//  customViewCellTableViewCell.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class customViewCellTableViewCell:
    UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var rightArrowBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.lineBreakMode = .byTruncatingTail
        
        rightArrowBtn.tintColor = .secondaryLabel
        
        self.backgroundColor = .systemBackground
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didTouchButton(_ sender: Any) {
        
    }
    

}
