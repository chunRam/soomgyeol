import Foundation

struct Mood: Identifiable, Equatable, Hashable {
    let id: String      // ✅ UUID가 아니라 고정된 string
    let name: String
    let emoji: String
    let colorName: String
    let message: String

    static let sampleMoods: [Mood] = [
        Mood(id: "happy", name: "행복", emoji: "😊", colorName: "SoftOrange", message: "행복한 순간을 더욱 깊게 느껴보세요."),
        Mood(id: "sad", name: "슬픔", emoji: "😢", colorName: "SoftBlue", message: "지금의 감정을 있는 그대로 바라보세요."),
        Mood(id: "angry", name: "분노", emoji: "😠", colorName: "RedSemi", message: "화가 나는 마음을 차분히 들여다보세요."),
        Mood(id: "calm", name: "평온", emoji: "😌", colorName: "SoftGreen", message: "지금의 평온함을 고요하게 이어가보세요."),
        Mood(id: "anxious", name: "불안", emoji: "😰", colorName: "Lavender", message: "불안한 마음을 부드럽게 안아주세요.")
    ]

    /// Helper to look up a `Mood` by its identifier string stored in `JournalEntry.mood`.
    static func mood(for id: String) -> Mood? {
        sampleMoods.first { $0.id == id }
    }
}
