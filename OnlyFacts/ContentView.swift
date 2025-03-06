//
//  ContentView.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/23/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var factsViewModel = FactsViewModel()
    
    @State private var isCreatingFact = false
    
    var body: some View {
        NavigationStack(path: $authViewModel.path) {
            VStack(alignment: .leading) {
                ToastErrorView(message: factsViewModel.errorMessage ?? "", isPresented: $factsViewModel.displayErrorMessage)
                
                MainHeader()

                ScrollView {
                    ForEach(factsViewModel.facts) { fact in
                        NavigationLink(value: fact) {
                            FactCardView(fact: fact)
                        }
                    }
                    
                }
                .navigationDestination(for: Fact.self) { fact in
                    FactDetails(fact: fact)
                }
                
                CreateFactButton(action: {
                    if authViewModel.authState == .loggedIn {
                        isCreatingFact.toggle()
                    } else {
                        authViewModel.navigateToAuth()
                    }
                })
            }
            .padding()
            .navigationDestination(for: String.self) { path in
                switch path {
                    case "login":
                        LoginView()
                    case "username":
                        UsernameView()
                    case "verification":
                        VerificationView()
                    default:
                        ErrorView(message: "An unknown error occurred. Please try again.")
                }
            }
            .sheet(isPresented: $isCreatingFact) {
                VStack {
                    SheetHeaderView(action: {
                        isCreatingFact.toggle()
                    })
                    Spacer()
                    CreateFactView()
                }
                .padding()
            }   
            .task {
                await factsViewModel.getFacts()
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(factsViewModel)
    }
}

#Preview {
    ContentView()
}
