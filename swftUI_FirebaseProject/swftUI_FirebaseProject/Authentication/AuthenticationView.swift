//
//  AuthenticationView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 19/06/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift



struct AuthenticationView: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            }
            
          
                Button( action: {
                    Task {
                        do {
                            try await viewModel.sigInAnonymous()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    Text("Sign In Anonymously")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                })
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.sigInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .shadow(radius: 10)
            .navigationTitle("Sign In")
        }
    }
    
    #Preview {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
