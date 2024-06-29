//
//  AuthenticationViewModel.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 28/06/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func sigInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        
    }
    
    func sigInAnonymous() async throws {
      let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
      
    }
}
