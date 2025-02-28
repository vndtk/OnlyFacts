//
//  AuthViewModel.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/24/25.
//

import Foundation
import SwiftUI
enum AuthState {
    case loggedIn, loggedOut, needsUsername, needsVerification
}

enum AuthError: Error {
    case userAlreadyExists, failedToSendOTP, failedToVerifyOTP, failedToUpdateProfile
}

struct AuthData {
    var email: String?
    var username: String?
    var token: String?
    var path: NavigationPath = NavigationPath()
}

class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .loggedOut
    @Published var authData: AuthData = AuthData()
    @Published var user: User?
    @Published var isLoading: Bool = false
    
    private let supabase = SupabaseService.shared
    
    init() {
        Task {
            await checkAuthState()
        }
    }

    @MainActor
    func checkAuthState() async {
        if let user = await supabase.getUser() {
            self.user = user
            if user.username == nil {
                self.authState = .needsUsername
                authData.path.append("username")
            } else {
                self.authState = .loggedIn
            }
        } else {
            self.authState = .loggedOut
        }
    }

    @MainActor
    func login(email: String) async throws{
        isLoading = true
        authData.email = email

        let isOTPSent = await supabase.sendOTP(email: email)
        if isOTPSent {
            self.authState = .needsVerification
            authData.path.append("verification")
        } else {
            isLoading = false
            throw AuthError.failedToSendOTP
        }

        isLoading = false
    }
    
    @MainActor
    func verify(code: String) async throws {
        isLoading = true
        
        guard let email = authData.email else {
            isLoading = false
            throw AuthError.failedToVerifyOTP
        }
        
        let result = await supabase.verifyOTP(email: email, token: code)
        if result {
            guard let user = await supabase.getUser() else {
                isLoading = false
                throw AuthError.failedToVerifyOTP
            }

            if user.username == nil {
                self.authState = .needsUsername
                authData.path.append("username")
            } else {
                self.authState = .loggedIn
            }
            
            self.user = user
        } else {
            isLoading = false
            throw AuthError.failedToVerifyOTP
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateUsername(username: String) async throws {
        isLoading = true

        guard let user = self.user else {
            isLoading = false
            throw AuthError.failedToUpdateProfile
        }

        let success = await supabase.updateUserProfile(user: user, username: username)
        if success {
            self.user = await supabase.getUser()
            authData.path = NavigationPath()
        } else {
            throw AuthError.failedToUpdateProfile
        }
        
        isLoading = false
    }

    func goBack() {
        authData.path.removeLast()
    }

    func navigateToAuth() {
        authState = .loggedOut
        authData.path = NavigationPath()
        authData.path.append("login")
    }
}
