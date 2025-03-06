import SwiftUI

struct VerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var otp: String = ""

    init() {
        print("VerificationView initialized.")
    }

    var body: some View {
        ZStack {
            BubbleView()

            VStack(alignment: .leading) {
                Spacer()

                Text("Verify OTP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)

                Text("Enter the code sent to your email:")
                    .padding(.bottom, 16)

                TextField("OTP", text: $otp)
                    .textFieldStyle(.roundedBorder)
                
                LoginButtonView(title: "Verify", action: {
                    Task {
                        await authViewModel.verify(code: otp)
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