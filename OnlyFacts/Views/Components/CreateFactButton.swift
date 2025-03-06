import SwiftUI

struct CreateFactButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            
            Button(action: action) {
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
        }
    }
}