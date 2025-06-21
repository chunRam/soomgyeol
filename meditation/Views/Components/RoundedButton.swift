import SwiftUI

struct RoundedButton: View {
    var title: String
    var backgroundColor: Color = .accentColor
    var textColor: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(16)
        }
    }
}

