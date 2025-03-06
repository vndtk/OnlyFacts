import SwiftUI

struct BubbleView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(.indigo.opacity(0.25))
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width * 0.5, y: -geometry.size.height * 0.4)
                
                Image(systemName: "brain.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 125)
                    .offset(x: -geometry.size.width * 0.5, y: -geometry.size.height * 0.2)
            }
        }
    }
}

#Preview {
    BubbleView()
        .frame(height: 200)
        .padding()
}