import SwiftUI

struct LoginButtonView: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.indigo)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Text(title)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.indigo)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .disabled(isLoading)
        
    }
}

