//
//  RootView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 20/06/24.
//

import SwiftUI

struct RootView: View {
    
    @State var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
              // TabbarView(showSignInView: $showSignInView)
                CrashView()
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            // se o usuario logado for = anulo entao retorne verdade, se for falso entao retorne falso 
            self.showSignInView = authUser == nil
        
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
