import SwiftUI

struct MoodCardView: View {
    let mood: Mood
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(mood.emoji)
                .font(.system(size: 44))

            Text(mood.name)
                .font(.system(size: 18, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(isSelected ? Color(mood.colorName) : Color("SoftGray"))
                .shadow(
                    color: .black.opacity(isSelected ? 0.2 : 0.05),
                    radius: isSelected ? 6 : 2,
                    y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isSelected ? Color(mood.colorName) : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
