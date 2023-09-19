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
    
    public var user: User? = nil // Change this to a property
    
    func loggedIn() -> Bool {
        return self.user != nil
    }
    
    func signUp(Name name: String,Email email: String,Password password: String) {
        saveUser(Name: name, Email: email, Password: password)
        
        let defualt = UserDefaults.standard
        defualt.set(true, forKey: "asSignedUp")
        
        
//        print("name: \(name)\n email: \(email)\n password: \(password)")
    }
    
    
    func signIn(Name _name: String,Email _email: String,Password _password: String) -> Bool{
        
        let user :User = loadUser()
        
//        print("name: \(user.name!)\n email: \(user.email!)\n password: \(user.password!)")
        
        if(user.name == _name && user.email == _email && user.password == _password) {
            self.user = user
            return true
        }
        
        return false
    }
    
    func loadUser() -> User {
        let defualt = UserDefaults.standard
        
        let name        = defualt.string(forKey: "name")
        let email       = defualt.string(forKey: "email")
        let password    = defualt.string(forKey: "password")
        
        return User(id: 0, name: name, email: email, password: password)
    }
    
    func saveUser(Name name: String,Email email: String,Password password: String) {
        let defualt = UserDefaults.standard
        
        defualt.set(name, forKey: "name")
        defualt.set(email, forKey: "email")
        defualt.set(password, forKey: "password")
    }
    
    func asSignUp() -> Bool {
        let defualt = UserDefaults.standard
        
        let flag = defualt.bool(forKey: "asSignedUp")
        
        return flag
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
