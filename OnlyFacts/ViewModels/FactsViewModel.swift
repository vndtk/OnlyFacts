//
//  FactsViewModel.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

import Foundation

class FactsViewModel: ObservableObject {
    @Published var facts: [Fact] = []
    
    private let supabase = SupabaseService.shared
    
    func getFacts() {
        print("Getting facts...")
        
        Task { @MainActor in
            do {
                let facts = try await supabase.getFacts()
                self.facts = facts
                print(facts)
            } catch {
                print(error)
            }
        }
    }
}
