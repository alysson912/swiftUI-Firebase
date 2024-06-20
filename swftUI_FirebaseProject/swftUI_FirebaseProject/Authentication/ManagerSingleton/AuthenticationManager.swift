//
//  AuthenticationManager.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 19/06/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email, photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    //MARK: func sincrona, para buscar o usuario authenticado
    func getAuthentication() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else { // verificar se o usuario esta logado localmente
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    // func asincrona, bate no servidor e volta 
    func createUser(email: String, password: String) async  throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authDataResult.user)
    }
    
    func sigOut() throws {
      try  Auth.auth().signOut() // como precisamos dar um ping no servidor entao essa funcao será assincrona 
    }
}
