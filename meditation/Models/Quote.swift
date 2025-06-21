import Foundation

struct Quote: Identifiable {
    let id = UUID()
    let text: String

    static let sampleQuotes: [Quote] = [
        Quote(text: "마음은 머무는 곳에 있다."),
        Quote(text: "호흡에 집중하며 마음을 비워보세요."),
        Quote(text: "오늘 하루도 자신에게 친절해지세요."),
        Quote(text: "편안한 호흡이 마음을 차분하게 합니다."),
        Quote(text: "현재의 순간에 집중해 보세요.")
    ]
}
