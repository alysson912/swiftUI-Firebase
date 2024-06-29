//
//  ProfileView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 28/06/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    // func  para buscar novamente no back-end usuario com os dados atualizados na tela
    // adicionando dos dados pela model
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserID: \(user.userId)")
                
                
                if let isAnonymous = user.isAnonymous {
                    Text( "Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button(action: {
                    viewModel.togglePremiumStatus()
                }, label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                })
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView( showSignInView: .constant(false))
    }
}
