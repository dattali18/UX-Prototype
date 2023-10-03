//
//  RoundedCornerSectionHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import UIKit

class RoundedCornerSectionHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)

            layer.cornerRadius = 50
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
