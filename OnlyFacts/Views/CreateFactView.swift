//
//  CreateFactView.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/24/25.
//

import SwiftUI

struct CreateFactView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var factsViewModel: FactsViewModel

    @State private var category: String = "General"
    @State private var content: String = ""
    @State private var isSubmitting = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: $content)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if content.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Share an interesting fact...")
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .allowsHitTesting(false)
                                        
                                        Spacer()
                                    }

                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    )
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Picker("Category", selection: $category) {
                    Text("General").tag("General")
                    Text("Food").tag("Food")
                    Text("Science").tag("Science")
                    Text("History").tag("History")
                    Text("Technology").tag("Technology")
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 3)
                )
                .padding(.vertical, 5)
            }
            
            Spacer()
            Button(action: {
                isSubmitting = true
                Task {
                    do {
                        try await factsViewModel.createFact(content: content, category: category)
                    } catch {
                        print("Error creating fact: \(error)")
                    }
                }
                isSubmitting = false
            }) {
                HStack {
                    Text("Submit")
                        .fontWeight(.semibold)
                        .padding()
                    
                    if isSubmitting {
                        ProgressView()
                            .padding(.leading, 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .disabled(content.isEmpty || isSubmitting)
            .opacity(content.isEmpty ? 0.6 : 1.0)
        }
    }
}

