import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var username: String = ""
    @State private var errorMessage: String?

    init() {
        print("UsernameView initialized.")
    }

    var body: some View {
        ZStack {
            BubbleView()
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text("Set Username")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)
                
                Text("Please enter a username that will be shown with your facts:")
                    .padding(.bottom, 16)
                
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                
                LoginButtonView(title: "Continue", action: {
                    Task {
                        do {
                            try await authViewModel.updateUsername(username: username)
                        } catch AuthError.failedToUpdateProfile {
                            errorMessage = "Error updating profile. Please try again."
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