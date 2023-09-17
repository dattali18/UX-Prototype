//
//  UserLogin.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import Foundation

class UserLogin {
    static let shared = UserLogin()
    
    private init() { } // Make the initializer private to prevent external instantiation
    
    public var user: User? // Change this to a property
    
    func loggedIn() -> Bool {
//        return self.user != nil
        return true
    }
}



struct User {
    let id: Int?
    let name: String?
    let email: String?
    let password: String?
    
    init(id: Int?, name: String?, email: String?, password: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
