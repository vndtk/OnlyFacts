import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var username: String = ""

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
                        await authViewModel.updateUsername(username: username)
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