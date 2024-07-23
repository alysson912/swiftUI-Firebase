//
//  OnFirstAppearViewModifier.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 23/07/24.
//

import SwiftUI
import Combine


struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let peform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                if !didAppear {
                   peform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    func onFirstApper(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(peform: perform))
    }
}
