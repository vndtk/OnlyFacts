//
//  LoginView.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/24/25.
//

import SwiftUI

struct BubbleView: View {
    var body: some View {
        GeometryReader { geometry in 
            Circle()
                .fill(.gray.opacity(0.2))
                .frame(width: geometry.size.width * 1.3)
                .offset(x: geometry.size.width * 0.2, y: -geometry.size.height * 0.2)
            
            Image(systemName: "bubble.left.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.indigo)
                .frame(width: 100)
                .offset(x: geometry.size.width * 0.6, y: geometry.size.height * 0.15)
        }
    }
}

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if authViewModel.authState == .needsUsername {
                    UsernameView()
                } else if authViewModel.authState == .needsVerification {
                    VerificationView()
                } else {
                    LoginView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authViewModel.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
