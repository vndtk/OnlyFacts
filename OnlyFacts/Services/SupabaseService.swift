//
//  SupabaseService.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

import Foundation
import Supabase
import HCaptcha

enum SupabaseError: Error {
    case failedToGetFacts, failedToGetCategories, failedToGetUser, failedToGetUserProfile, failedToCreateFact, failedToSendOTP, failedToVerifyOTP, failedToUpdateProfile, failedToSignIn
}

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    private init() {
        let url = URL(string: "https://obzvjeduydfnzvcxrthf.supabase.co")!
        client = SupabaseClient(supabaseURL: url, supabaseKey: Config.supabaseKey)
    }

    func getFacts() async throws -> [Fact]? {
        do {
            let facts: [Fact] = try await client
                .from("facts")
                .select()
                .execute()
                .value

            print("Facts:\n \(facts)")

            return facts
        } catch {
            print("Error getting facts: \(error.localizedDescription)")
            throw SupabaseError.failedToGetFacts
        }
    }

    func getUser() async throws -> User? {
        do {
            let user = try await client.auth.user()
            return User(id: user.id, email: user.email ?? "", profile: nil)
        } catch {
            print("Error getting user: \(error)")
            throw SupabaseError.failedToGetUser
        }
    }

    func getUserProfile(id: String) async throws -> UserProfile? {
        do {
            let profile: UserProfile = try await client.from("profiles")
                .select()
                .eq("user_id", value: id)
                .single()
                .execute()
                .value

            return profile
        } catch {
            print("Error getting user profile: \(error)")
            throw SupabaseError.failedToGetUserProfile
        }
    }

    func signIn(captcha: String) async throws {
        do {
            try await client.auth.signInAnonymously(captchaToken: captcha)
        } catch {
            print("Error signing in: \(error)")
            throw SupabaseError.failedToSignIn
        }
    }

    func sendOTP(email: String) async throws {
        do {
            try await client.auth.signInWithOTP(email: email)
        } catch {
            print("Error sending OTP: \(error)")
            throw SupabaseError.failedToSendOTP
        }
    }
    
    func verifyOTP(email: String, token: String) async throws {
        do {
            try await client.auth.verifyOTP(email: email, token: token, type: .email)
        } catch {
            print("Error verifying OTP: \(error)")
            throw SupabaseError.failedToVerifyOTP
        }
    }

    func updateUserProfile(user: User, username: String) async throws {
        do {
            if let _ = try await getUserProfile(id: user.id.uuidString) {
                try await client.from("profiles")
                    .update(["username": username])
                    .eq("user_id", value: user.id.uuidString)
                    .execute()
            } else {
                try await client.from("profiles")
                    .insert(["user_id": user.id.uuidString, "username": username])
                    .execute()
            }
        } catch {
            print("Error updating profile: \(error)")
            throw SupabaseError.failedToUpdateProfile
        }
    }

    func createFact(fact: Fact) async throws {
        do {
            let response = try await client.from("facts").insert(fact).execute()
        } catch {
            print("Error creating fact: \(error)")
            throw SupabaseError.failedToCreateFact
        }
    }
}
