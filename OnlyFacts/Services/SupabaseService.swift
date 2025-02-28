//
//  SupabaseService.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    private init() {
        let url = URL(string: "https://obzvjeduydfnzvcxrthf.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ienZqZWR1eWRmbnp2Y3hydGhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyOTM5MjIsImV4cCI6MjA1NTg2OTkyMn0.I3p-m2YH9KHlCwVtEMtYcjJrV6MVuG_-_LcPaNxZdMI"
        
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    func getFacts() async throws -> [Fact] {
        let response = try await client.from("facts").select().execute()
        let facts = try JSONDecoder().decode([Fact].self, from: response.data)
        return facts
    }
    
    func sendOTP(email: String) async -> Bool {
        do {
            try await client.auth.signInWithOTP(email: email)
            return true
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
            return false
        }
    }
    
    func verifyOTP(email: String, token: String) async -> Bool {
        do {
            let _ = try await client.auth.verifyOTP(email: email, token: token, type: .email)
            return true
        } catch {
            print("Failed to sign up: \(error.localizedDescription)")
            return false
        }
    }
    
    func getUser() async -> User? {
        do {
            let user = try await client.auth.user()
            
            if let profile = await getUserProfile(id: user.id.uuidString) {
                return User(id: user.id, email: user.email ?? "", username: profile.username)
            }
            
            return User(id: user.id, email: user.email ?? "", username: nil)
        } catch {
            print("Error getting user: \(error)")
            return nil
        }
    }
    
    func updateUserProfile(user: User, username: String) async -> Bool {
        do {
            // Check if profile exists
            let profile = await getUserProfile(id: user.id.uuidString)
            if profile == nil {
                try await client.from("profiles")
                    .insert(["user_id": user.id.uuidString, "username": username])
                    .execute()
            } else {
                try await client.from("profiles")
                    .update(["username": username])
                    .eq("user_id", value: user.id.uuidString)
                    .execute()
            }

            return true
        } catch {
            print("Error updating profile: \(error)")
            return false
        }
    }

    func getUserProfile(id: String) async -> UserProfile? {
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
            return nil
        }
    }
}
