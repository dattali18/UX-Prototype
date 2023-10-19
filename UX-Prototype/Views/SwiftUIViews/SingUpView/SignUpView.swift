//
//  SignInFormView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import SwiftUI

struct SignUpView: View {
    weak var navigationDelegate:    NavigationViewDelegate?
    weak var loginDelegate:         UserLoginViewDelegate?
    
    @State private var fName: String = ""
    @State private var lName: String = ""
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                // User Info Text
                Section("User Info") {
                    TextField("First Name", text: $fName)
                    TextField("Last Name", text: $lName)
                }
                
                // User Email
                Section("User Email") {
                    TextField("Email", text: $email)
                }
                
                // Password
                Section(content: {
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }, header: {
                    Text("Password")
                }, footer: {
                    Text("Please make sure the password is at least 8 character long.")
                })
                
                Section {
                   
                } footer: {
                    Button {
                        // FIXME: - Implement delegate
                        loginDelegate?.Login()
                    } label: {
                        HStack
                        {
                            Spacer()
                            Text("Sign In")
                            Spacer()
                        }
                        .frame(width: 350, height: 30)
                    }

                    .buttonStyle(.borderedProminent)
                }
                
                Section {
 
                } footer : {
                    HStack {
                        Text("Allready have an account?")
                            .font(.subheadline)
                        Spacer()
                        Button("Sign In") {
                            navigationDelegate?.navigate()
                        }
                    }
                }
                
            }
            .navigationTitle("Sign Up")
            .onTapGesture {
                    hideKeyboard()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
}
