//
//  SettingsView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 20/06/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProvider() {
            authProviders = providers
        }
    }
    
    func loadAuthUser()  {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try  AuthenticationManager.shared.sigOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "almenezes912@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Cross912@"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        
    }
    
    func linkEmailAccount() async throws {
        let email = "almenezes912@gmail.com" // evitando criar form (por enquanto)
        let password = "Cross912@"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error )
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error )
                    }
                }
            } label: {
                Text("Delete account")
            }

            
            if viewModel.authProviders.contains(.email) {
                EmailSectionView()
            }
            
            if viewModel.authUser?.isAnonymous == true {
                AnonymousSectionView()
            }
            
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

struct EmailSectionView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        Section {
            
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET! ")
                    } catch {
                        print(error )
                    }
                }
            }
            
            Button("Update e-mail") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("UPDATED E-MAIL! ")
                    } catch {
                        print(error )
                    }
                }
            }
            
            Button("Update password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("UPDATED PASSWORD! ")
                    } catch {
                        print(error )
                    }
                }
            }
        } header: {
            Text("Email functions")
        }
    }
}

struct AnonymousSectionView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Section {
            
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("GOOGLE LINKED! ")
                    } catch {
                        print(error )
                    }
                }
            }
        
            Button("Link Email Account") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("EMAIL LINKED! ")
                    } catch {
                        print(error )
                    }
                }
            }
        } header: {
            Text("Create account")
        }
    }
}
