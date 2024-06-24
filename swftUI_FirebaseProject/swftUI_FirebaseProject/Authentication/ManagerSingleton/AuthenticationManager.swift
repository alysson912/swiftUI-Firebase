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
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else { // verificar se o usuario esta logado localmente
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    //MARK: CRIAR USUARIO
    // func asincrona, bate no servidor e volta
    @discardableResult // == sabemos que tem um retorno vindo mas nao nos importamos com ele 
    func createUser(email: String, password: String) async  throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authDataResult.user)
    }
    
    //MARK: logar com email ja existente
    @discardableResult
    func signInUser(email: String, password: String) async  throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
       return AuthDataResultModel(user: authDataResult.user)
    }
    
    //MARK: RESETAR A SENHA
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    //MARK: ATUALIZAR A SENHA
    func updatePassword(password: String) async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
      try await user.updatePassword(to: password)
    }
    
    //MARK: ATUALIZAR A SENHA
    func updateEmail(email: String) async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        //MARK: will be Deprecated, PROCURAR POR OUTRA SOLUCAO PARA ATUALIZAR EMAIL
      try await user.updateEmail(to: email)
    }
    
    //MARK: Deslogar a conta
    func sigOut() throws {
      try  Auth.auth().signOut() // como precisamos dar um ping no servidor entao essa funcao será assincrona 
    }
}
