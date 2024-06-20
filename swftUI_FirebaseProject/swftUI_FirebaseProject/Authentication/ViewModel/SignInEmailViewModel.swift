//
//  SignInEmailViewModel.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 19/06/24.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn()  {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        Task {
            do {
                let returnedUserData = try await  AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error \(error)")
            }
        }
    
    }
}
