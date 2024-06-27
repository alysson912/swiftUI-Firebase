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
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
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
    
    // esconder email settings ao logar com google
    func getProvider() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found \(provider.providerID)")
            }
        }
        return providers
    }
    
    //MARK: Deslogar a conta
    func sigOut() throws {
        try  Auth.auth().signOut() // como precisamos dar um ping no servidor entao essa funcao será assincrona
    }
}

//MARK: SIGN IN EMAIL FUNCTIONS
extension AuthenticationManager {
    
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
}

// MARK: SIGN IN SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

//MARK: SIGN IN ANOUNYMOUS

extension AuthenticationManager {
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    //VINCULANDO EMAIL CASO O USUARIO ANONIMO QUEIRA FAZER ALGO NO APP
    func linkEmail( email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential: credential)
    }
    
    // VINCULANDO SIGIN IN WITH GOOGLE
    
    func linkGoogle(tokens: GoogleSignResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential: credential)
    }
    
    private func linkCredential(credential: AuthCredential) async throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError( .badURL)
        }
        
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    
    
}
