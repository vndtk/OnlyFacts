import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 16)
            
            if let user = authViewModel.user {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.indigo)
                        
                        VStack(alignment: .leading) {
                            Text(user.username ?? "No username set")
                                .font(.headline)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 5)
                    )

                    Spacer()
                    
                    // Button(action: {
                    //     // Edit profile action would go here
                    // }) {
                    //     HStack {
                    //         Image(systemName: "pencil")
                    //         Text("Edit Profile")
                    //     }
                    //     .frame(maxWidth: .infinity)
                    //     .padding()
                    //     .background(Color.indigo)
                    //     .foregroundColor(.white)
                    //     .cornerRadius(10)
                    // }
                }
            } else {
                Text("Please log in to view your profile")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}