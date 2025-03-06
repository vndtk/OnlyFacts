import Foundation
import SwiftUI

enum AuthState {
    case loggedIn, loggedOut, needsUsername, needsVerification
}

class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .loggedOut
    @Published var path = NavigationPath()

    @Published var isLoading = false
    @Published var displayError = false
    @Published var errorMessage: String?
    @Published var user: User?
    
    private let supabase = SupabaseService.shared
    
    init() {
        Task {
            await checkAuthState()
        }
    }

    @MainActor
    func checkAuthState() async {
        do {
            if var user = try await supabase.getUser() {
                if let profile = try await supabase.getUserProfile(id: user.id.uuidString) {
                    user.profile = profile
                } else {
                    authState = .needsUsername
                }

                self.user = user
            } else {
                authState = .loggedOut
            }
        } catch {
            authState = .loggedOut
        }
    }

    func signIn() async {
        defer { isLoading = false }

        isLoading = true

        do {
            try await supabase.signIn()
        } catch {
            errorMessage = "Failed to sign in. Please try again."
            displayError = true
        }
    }

    @MainActor
    func login(email: String) async {
        defer { isLoading = false }

        isLoading = true

        let newUser = User(id: UUID(), email: email, profile: nil)
        do {
            try await supabase.sendOTP(email: email)
            authState = .needsVerification
            path.append("verification")
            user = newUser
        } catch {
            errorMessage = "Failed to send OTP. Please try again."
            displayError = true
        }
    }
    
    @MainActor
    func verify(code: String) async {
        guard let user = self.user else {
            isLoading = false
            errorMessage = "Failed to verify OTP. Please try again."
            displayError = true
            return
        }

        defer { isLoading = false }

        isLoading = true
        
        do {
            print("Verifying OTP: \(code)")

            try await supabase.verifyOTP(email: user.email, token: code)
            if var user = try await supabase.getUser() {
                print("User: \(user)")
                if let profile = try await supabase.getUserProfile(id: user.id.uuidString) {
                    print("Profile: \(profile)")
                    user.profile = profile
                    authState = .loggedIn
                    path = NavigationPath()
                } else {
                    print("No profile found")
                    authState = .needsUsername
                }

                self.user = user
            }
        } catch {
            errorMessage = "Failed to verify OTP. Please try again."
            displayError = true
        }
    }
    
    @MainActor
    func updateUsername(username: String) async {
        guard let user = self.user else {
            isLoading = false
            errorMessage = "Failed to update username. Please try again."
            displayError = true
            return
        }
        defer { isLoading = false }

        isLoading = true

        do {
            try await supabase.updateUserProfile(user: user, username: username)
            authState = .loggedIn
        } catch {
            errorMessage = "Failed to update username. Please try again."
            displayError = true
        }
    }

    func goBack() {
        path.removeLast()
    }

    func navigateToAuth() {
        authState = .loggedOut
        path.append("login")
    }
}
