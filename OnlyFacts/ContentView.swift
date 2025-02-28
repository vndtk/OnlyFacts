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
    
    @State private var isCreatingFact: Bool = false

    init() {
        print("ContentView initialized.")
    }
    
    var body: some View {
        NavigationStack(path: $authViewModel.authData.path) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Facts")
                        .font(.largeTitle)
                        .bold()

                    Spacer()
                    
                    if authViewModel.authState == .loggedIn {
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                }

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
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if authViewModel.authState == .loggedIn {
                            isCreatingFact.toggle()
                        } else {
                            authViewModel.navigateToAuth()
                        }
                    }) {
                        ZStack {
                            Circle().fill(.indigo)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFill()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
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
                }
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
        }
        .environmentObject(authViewModel)
        .task {
            factsViewModel.getFacts()
        }
        
        
    }
}

#Preview {
    ContentView()
}
