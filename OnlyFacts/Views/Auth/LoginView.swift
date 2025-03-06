import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""

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
                        await authViewModel.login(email: email)
                    }
                }, isLoading: authViewModel.isLoading)

                if let errorMessage = authViewModel.errorMessage {
                    InlineErrorView(message: errorMessage)
                }
            }
            .padding()
        }
    }
}
