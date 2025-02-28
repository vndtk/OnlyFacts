import SwiftUI

struct VerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var otp: String = ""
    @State private var errorMessage: String?

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
                        do {
                            try await authViewModel.verify(code: otp)
                        } catch AuthError.failedToVerifyOTP {
                            errorMessage = "Error verifying OTP. Please check your email and try again."
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