//
//  ProfileView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 28/06/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    
    var body: some View {
        
        if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .shadow(radius: 1.4)
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 150)
            }
        }
        
        if viewModel.user?.profileImagePath != nil {
            Button("Delete Image") {
                viewModel.deleteProfileImage()
            }
        }
        

        List {
            if let user = viewModel.user {
                Text("UserID: \(user.userId)")
                
                
                if let isAnonymous = user.isAnonymous {
                    Text( "Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack {
                        
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferenceIsSelected(text: string) {
                                    viewModel.removeUserPreferences(text: string)
                                } else {
                                    viewModel.addUserPreferences(text: string)
                                }
                                
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                        }
                        
                    }
                    
                    // Parenteses extra para converter o array em string
                    Text("User preferences: \((user.preferences ?? [] ).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie:  \((user.favoriteMovie?.title ?? ""))")
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
                    Text("Select a photo")
                }
                
             
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        
        .onChange(of: selectedItem, initial: false, { oldValue, newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
            }
        })
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
        ProfileView( showSignInView: .constant( false))
    }
    
    //RootView()
}
