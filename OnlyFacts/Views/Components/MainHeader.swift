import SwiftUI

struct MainHeader: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        HStack {
            Text("Facts")
                .font(.largeTitle)
                .bold()

            Spacer()
            
            if authViewModel.authState == .loggedIn {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}