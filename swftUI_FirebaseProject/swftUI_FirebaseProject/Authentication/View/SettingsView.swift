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
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProvider() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try  AuthenticationManager.shared.sigOut()
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
            if viewModel.authProviders.contains(.email) {
                EmailFunctionsView()
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

struct EmailFunctionsView: View {
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

