//
//  CrashView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 14/08/24.
//

import SwiftUI
import FirebaseCrashlytics

struct CrashView: View {
    var body: some View {
        VStack (spacing: 20 ){
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            Button("Click me 1 ") {
                CrashManager.shared.addLog(message: "Button_1_clicked")
                let myString: String? = nil
                
                guard let myString else {
                    CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                    return
                }
                
                let string2 = myString
            }
            
            Button("Click me 2 ") {
                CrashManager.shared.addLog(message: "Button_2_clicked")
                fatalError("This was a fatal crash ")
            }
            
            Button("Click me 3 ") {
                
                CrashManager.shared.addLog(message: "Button_3_clicked")
                
                let arrayString: [String] = []
                let item = arrayString[0]
                
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "A123")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(message: "crash_view_appeared")
            CrashManager.shared.addLog(message: "Crash_view_appeared on user`s screen")
        }
    }
}

#Preview {
    CrashView()
}
