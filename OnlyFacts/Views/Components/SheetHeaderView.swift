import SwiftUI

struct SheetHeaderView: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                HStack {
                    Text("Cancel")
                }
            }
            
            Spacer()
        }
    }
}