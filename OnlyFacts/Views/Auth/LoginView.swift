import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var errorMessage: String?

    init() {
        print("LoginView initialized.")
    }

    var body: some View {
        ZStack {
            BubbleView()
            
            VStack(alignment: .leading) {
                Spacer()

                Text("Welcome to Only Facts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)

                Text("To be able to create and vote on facts, you need to log in. Please enter your email below.")
                    .padding(.bottom, 24)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                
                LoginButtonView(title: "Log in", action: {
                    Task {
                        do {
                            try await authViewModel.login(email: email)
                        } catch AuthError.failedToSendOTP {
                            errorMessage = "Error sending OTP. Please try again."
                        } catch {
                            errorMessage = "An unknown error occurred. Please try again."
                        }
                    }
                }, isLoading: authViewModel.isLoading)

                if let errorMessage = errorMessage {
                    InlineErrorView(message: errorMessage)
                }
            }
            .padding()
        }
    }
}