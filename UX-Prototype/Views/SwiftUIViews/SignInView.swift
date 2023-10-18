///
///  SignInView.swift
///  UX-Prototype
///
///  Created by `Daniel Attali` on 10/18/23.
///

import SwiftUI

struct SignInView: View {
    weak var navigationDelegate:    NavigationViewDelegate?
    weak var loginDelegate:         UserLoginViewDelegate?
    
    @State private var password: String = ""
    
    @State private var email: String = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section("User Email") {
                    TextField("Email", text: $email)
                }
                
                Section("User Password") {
                    SecureField("Password", text: $password)
                }
                   
                Section {
                   
                } footer: {
                    Button {
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
                   
                } footer: {
                    HStack {
                        Text("Allready have an account?")
                            .font(.subheadline)
                        Spacer()
                        Button("Sign Up") {
                            // FIXME: - Create Delegate
                            navigationDelegate?.navigate()
                        }
                    }
                }
            }
            .navigationTitle("Sign In")
            .toolbar {
                // Add a "Save" button to the top of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                    }
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
