//
//  ErrorView.swift
//  OnlyFacts
//
//  Created by Vlady Schmidt on 2/24/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: (() -> Void)?
    let dismissAction: (() -> Void)?
    
    init(
        message: String,
        retryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.retryAction = retryAction
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.indigo)
                .padding(.bottom, 8)
            
            Text("Error")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                if let retryAction = retryAction {
                    Button(action: retryAction) {
                        Text("Try Again")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
                
                if let dismissAction = dismissAction {
                    Button(action: dismissAction) {
                        Text("Dismiss")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.indigo)
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 2)
        )
        .padding()
    }
}

// Toast-style error view that appears at the bottom of the screen
struct ToastErrorView: View {
    let message: String
    let isPresented: Binding<Bool>
    
    var body: some View {
        VStack {
            Spacer()
            
            if isPresented.wrappedValue {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.indigo)
                )
                .padding(.horizontal)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            }
        }
    }
}

// Inline error view for form fields
struct InlineErrorView: View {
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .font(.caption)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.top, 4)
    }
}

#Preview {
    VStack(spacing: 40) {
        ErrorView(
            message: "Something went wrong while loading facts. Please check your internet connection and try again.",
            retryAction: {},
            dismissAction: {}
        )
        
        InlineErrorView(message: "Please enter a valid email address")
        
        Color.clear
            .overlay(
                ToastErrorView(
                    message: "Failed to send verification code",
                    isPresented: .constant(true)
                )
            )
    }
    .padding()
}
