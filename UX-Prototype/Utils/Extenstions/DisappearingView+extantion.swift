//
//  DisappearingView+extantion.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/17/23.
//

import Foundation

protocol DisappearingViewDelegate: AnyObject {
    func viewWillDisappear()
}

protocol NavigationViewDelegate: AnyObject {
    func navigate()
}

protocol UserLoginViewDelegate: AnyObject {
    func Login()
}
